# q-prompts

A store of reusable skills, agent definitions, and hook assets for **Codex,
Claude Code, OpenCode, and Qwen Code**.

## Store layout

```text
skills/<skill-name>/SKILL.md
agents/{codex,claude,opencode,qwen}/
hooks/{codex,claude,opencode,qwen}/
```

Skills are shared across tools, and installers copy each complete skill directory,
including references and assets. `agents/` and `hooks/` reserve separate folders
for each tool's native formats. They currently contain only `.gitkeep`
placeholders; installers create their destination folders but do not copy the
placeholders. Add agent definitions and hook files under the appropriate tool.

## Installation

Download or clone this repository, then run the installer from your local copy.
No administrator privileges or additional packages are required.

Choose a tool with `--agent` (Bash) or `-Agent` (PowerShell). The default is
`codex`; choose `all` to install for all four tools.

### Default destinations

| Tool | Skills | Agent definitions | Hook assets |
| --- | --- | --- | --- |
| `codex` | `~/.agents/skills` | `~/.codex/agents` | `~/.codex/hooks` |
| `claude` | `~/.claude/skills` | `~/.claude/agents` | `~/.claude/hooks` |
| `opencode` | `~/.config/opencode/skills` | `~/.config/opencode/agents` | `~/.config/opencode/hooks` |
| `qwen` | `~/.qwen/skills` | `~/.qwen/agents` | `~/.qwen/hooks` |

`~` means your home directory on Linux/macOS and `$HOME` in Windows PowerShell.
`CODEX_HOME` overrides Codex's agent/hook root, `CLAUDE_CONFIG_DIR` overrides
Claude's root, and `XDG_CONFIG_HOME` overrides OpenCode's `.config` root.
Codex skills continue to use `~/.agents/skills` when `CODEX_HOME` is set.

The skills and agent locations follow the official documentation for
[Codex skills](https://learn.chatgpt.com/docs/build-skills),
[Codex agents](https://learn.chatgpt.com/docs/agent-configuration/subagents),
[Claude skills](https://code.claude.com/docs/en/skills),
[Claude agents](https://code.claude.com/docs/en/sub-agents),
[OpenCode skills](https://opencode.ai/docs/skills/),
[OpenCode agents](https://opencode.ai/docs/agents/),
[Qwen skills](https://qwenlm.github.io/qwen-code-docs/en/users/features/skills/), and
[Qwen agents](https://qwenlm.github.io/qwen-code-docs/en/users/features/sub-agents/).
Agent definitions must use the selected tool's supported format and may require
additional configuration, depending on the tool/version.

### Linux and macOS

Requires Bash 3.2 or newer, available by default on macOS and many Linux systems.

```bash
# Install all skills and any reserved assets for Codex (the default).
bash ./install.sh

# Choose a tool, or install for all four.
bash ./install.sh --agent claude
bash ./install.sh --agent opencode
bash ./install.sh --agent qwen
bash ./install.sh --agent all

# Choose multiple tools and selected skills.
bash ./install.sh --agent codex --agent claude java-development java-junit

# Custom skills destination; agents/ and hooks/ are created beside skills/.
bash ./install.sh --agent claude --dest "$HOME/my-project/.claude/skills"

# Replace existing skills and conflicting agent/hook files.
bash ./install.sh --agent all --force

bash ./install.sh --help
```

### Windows

Run in Windows PowerShell 5.1 or PowerShell 7+:

```powershell
# Install for Codex (the default).
.\install.ps1

# Choose a tool, or install for all four.
.\install.ps1 -Agent claude
.\install.ps1 -Agent opencode
.\install.ps1 -Agent qwen
.\install.ps1 -Agent all

# Choose multiple tools and selected skills.
.\install.ps1 -Agent codex,claude -Skill java-development,java-junit

# Custom skills destination; agents/ and hooks/ are siblings.
.\install.ps1 -Agent claude -Destination "$HOME\my-project\.claude\skills"

# Replace existing skills and conflicting agent/hook files.
.\install.ps1 -Agent all -Force
```

If Windows blocks local scripts, run this command from the repository directory
to allow this installer for that PowerShell process:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Agent all
```

A custom destination requires exactly one selected tool. To install into a
project, use a local copy of this store outside that project directory: installers
reject destinations inside the store checkout. On Windows, destination paths
must not traverse symlinks or junctions.

### Hook registration

The `hooks/` destinations above store files; copying a script there does not
automatically register a hook. Configure the installed files through the tool's
[Codex hooks](https://learn.chatgpt.com/docs/hooks),
[Claude hooks](https://code.claude.com/docs/en/hooks), or
[Qwen hooks](https://qwenlm.github.io/qwen-code-docs/en/users/features/hooks/)
configuration. For OpenCode, use its
[plugin configuration](https://opencode.ai/docs/plugins/); the reserved
`opencode/hooks` directory is an asset location, not an automatic discovery path.
The installers do not edit existing tool settings or execute hook scripts.

### Updates and existing files

Existing skills and agent/hook files are skipped by default. After updating your
local repository, rerun with `--force` (Bash) or `-Force` (PowerShell). Each selected
skill directory is replaced entirely, removing local edits and obsolete files.
Agent and hook assets merge by file: only conflicting files are replaced, so
unrelated personal definitions and scripts remain. Selecting skills limits only
skills; agent and hook assets for the selected tools are always installed.
Restart your agent session after installation to load the new files.

## Verification

Run the Bash installer integration checks with Python 3:

```bash
python3 -B -m unittest discover -s tests -v
```

## Available skills

| Skill | Purpose |
| --- | --- |
| `agent-architecture` | Design and review agent architectures. |
| `frontend-development` | Deliver TypeScript/React features with OpenSpec and code, performance, and reliability reviews. |
| `create-spring-boot-java-project` | Create Spring Boot Java projects. |
| `hexagonal-architecture-review` | Review ports, adapters, and architectural boundaries. |
| `java-add-graalvm-native-image-support` | Add GraalVM native image support. |
| `java-debugging` | Debug Java applications. |
| `java-development` | Develop and maintain plain Java applications. |
| `java-diagnostics` | Diagnose Java runtime and performance problems. |
| `java-hibernate-jpa` | Work with Hibernate and JPA persistence. |
| `java-junit` | Write and maintain Java tests. |
| `java-mcp-server-generator` | Generate Java MCP servers. |
| `java-refactoring-extract-method` | Extract methods from Java code. |
| `java-refactoring-remove-parameter` | Remove unnecessary Java parameters. |
| `java-springboot` | Develop Spring Boot applications. |
| `java-testcontainers` | Test with containerized dependencies. |
| `java-upgrade` | Upgrade Java versions. |
| `openapi-to-application-java-spring-boot` | Build Spring Boot applications from OpenAPI specifications. |
| `web-design-reviewer` | Review web design and usability. |
