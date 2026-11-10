"""Exercise installation in a temporary store without modifying user settings."""
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


@unittest.skipUnless(shutil.which('bash'), 'Bash is required')
class InstallTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='q-prompts-test-')
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.store = self.root / 'store'
        self.store.mkdir()
        shutil.copy2(Path(__file__).resolve().parents[1] / 'install.sh', self.store)
        self.write('skills/example/SKILL.md', 'example skill')
        self.write('skills/example/references/guide.md', 'supporting file')
        self.write('skills/other/SKILL.md', 'other skill')
        for tool in ('codex', 'claude', 'opencode', 'qwen'):
            for category in ('agents', 'hooks'):
                self.write(f'{category}/{tool}/.gitkeep', '')
        self.destination = self.root / 'install with spaces' / 'skills'

    def write(self, relative, text):
        location = self.store / relative
        location.parent.mkdir(parents=True, exist_ok=True)
        location.write_text(text)
        return location

    def run_install(self, *arguments, success=True, destination=None):
        result = subprocess.run(
            ['bash', str(self.store / 'install.sh'), '--dest',
             str(destination or self.destination), *arguments],
            cwd=self.root, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode == 0, success, result.stdout + result.stderr)
        return result

    def test_empty_reserved_folders_and_complete_skill_copy(self):
        self.run_install()
        self.assertEqual((self.destination / 'example/references/guide.md').read_text(), 'supporting file')
        self.assertTrue((self.destination / 'other/SKILL.md').is_file())
        for category in ('agents', 'hooks'):
            folder = self.destination.parent / category
            self.assertTrue(folder.is_dir())
            self.assertEqual(list(folder.iterdir()), [])

    def test_each_tool_installs_only_its_assets(self):
        for tool in ('codex', 'claude', 'opencode', 'qwen'):
            self.write(f'agents/{tool}/reviewer.md', tool)
            hook = self.write(f'hooks/{tool}/nested/check.sh', tool)
            hook.chmod(0o755)
            self.write(f'hooks/{tool}/.hidden', tool)
        for tool in ('codex', 'claude', 'opencode', 'qwen'):
            with self.subTest(tool=tool):
                destination = self.root / tool / 'skills'
                self.run_install('--agent', tool, 'example', destination=destination)
                self.assertFalse((destination / 'other').exists())
                self.assertEqual((destination.parent / 'agents/reviewer.md').read_text(), tool)
                hook = destination.parent / 'hooks/nested/check.sh'
                self.assertEqual(hook.read_text(), tool)
                self.assertTrue(hook.stat().st_mode & 0o111)
                self.assertEqual((destination.parent / 'hooks/.hidden').read_text(), tool)
                self.assertFalse(list(destination.parent.rglob('.gitkeep')))

    def test_skip_and_force_preserve_unrelated_assets(self):
        self.write('agents/codex/team/reviewer.md', 'new agent')
        self.write('hooks/codex/check.sh', 'new hook')
        self.run_install()
        agent = self.destination.parent / 'agents/team/reviewer.md'
        hook = self.destination.parent / 'hooks/check.sh'
        skill = self.destination / 'example/SKILL.md'
        for location in (agent, hook, skill):
            location.write_text('local edit')
        unrelated = agent.with_name('personal.md')
        unrelated.write_text('personal agent')
        stale = skill.with_name('obsolete.txt')
        stale.write_text('obsolete')
        self.run_install()
        for location in (agent, hook, skill):
            self.assertEqual(location.read_text(), 'local edit')
        self.run_install('--force')
        self.assertEqual(agent.read_text(), 'new agent')
        self.assertEqual(hook.read_text(), 'new hook')
        self.assertEqual(skill.read_text(), 'example skill')
        self.assertFalse(stale.exists())
        self.assertEqual(unrelated.read_text(), 'personal agent')

    def test_invalid_arguments_fail_before_installing(self):
        for arguments in [('--agent', 'unknown'), ('--agent',), ('../example',),
                          ('example', 'missing'), ('--agent', 'all'),
                          ('--agent', 'codex', '--agent', 'claude'), ('--unknown',)]:
            with self.subTest(arguments=arguments):
                self.run_install(*arguments, success=False)
                self.assertFalse(self.destination.exists())

    def test_source_directory_is_protected(self):
        before = (self.store / 'skills/example/SKILL.md').read_text()
        self.run_install('--force', destination=self.store / 'skills', success=False)
        self.assertEqual((self.store / 'skills/example/SKILL.md').read_text(), before)

    def test_symlink_into_source_is_protected(self):
        alias = self.root / 'alias'
        alias.symlink_to(self.store / 'skills', target_is_directory=True)
        self.run_install('--force', destination=alias, success=False)
        self.assertEqual((self.store / 'skills/example/SKILL.md').read_text(), 'example skill')

    def test_custom_destination_trailing_slash(self):
        self.run_install(destination=str(self.destination) + '/')
        self.assertTrue((self.destination.parent / 'agents').is_dir())
        self.assertFalse((self.destination / 'agents').exists())


if __name__ == '__main__':
    unittest.main()
