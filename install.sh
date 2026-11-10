#!/usr/bin/env bash
# Install skills, agent definitions, and hook assets (Bash 3.2+).
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: bash install.sh [--agent TOOL] [--dest DIRECTORY] [--force] [SKILL ...]

Install all skills, or only the named skills, plus tool-specific agents/hooks.
  --agent TOOL      codex (default), claude, opencode, qwen, or all.
                    Repeat this option to select multiple tools.
  --dest DIRECTORY  Custom skills directory for one tool; agents/hooks are siblings.
  --force           Replace existing skills and conflicting agent/hook files.
  --help            Show this help.
EOF
}

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
repository="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source_root="$repository/skills"
destination=''
tools=()
force=false
skills=()
while [ "$#" -gt 0 ]; do
    case "$1" in
        --agent)
            [ "$#" -ge 2 ] && [ -n "$2" ] || die '--agent requires a tool name.'
            case "$2" in
                codex|claude|opencode|qwen) tools+=("$2") ;;
                all) tools+=(codex claude opencode qwen) ;;
                *) die "Unknown tool: $2" ;;
            esac
            shift 2 ;;
        --dest)
            [ "$#" -ge 2 ] && [ -n "$2" ] || die '--dest requires a directory.'
            destination="$2"; shift 2 ;;
        --force) force=true; shift ;;
        --help|-h) usage; exit 0 ;;
        --*) die "Unknown option: $1" ;;
        *) skills+=("$1"); shift ;;
    esac
done
[ "${#tools[@]}" -gt 0 ] || tools=(codex)
if [ -n "$destination" ] && [ "${#tools[@]}" -ne 1 ]; then
    die '--dest requires exactly one tool.'
fi

[ -d "$source_root" ] || die "Skills directory not found: $source_root"
if [ "${#skills[@]}" -eq 0 ]; then
    for directory in "$source_root"/*; do
        [ -f "$directory/SKILL.md" ] || continue
        skills+=("${directory##*/}")
    done
fi
[ "${#skills[@]}" -gt 0 ] || die 'No skills found.'
for skill in "${skills[@]}"; do
    case "$skill" in
        ''|.|..|*/*|*\\*) die "Invalid skill name: $skill" ;;
    esac
    [ -f "$source_root/$skill/SKILL.md" ] || die "Unknown skill: $skill"
done

# Resolve symlinks before copying, including at every nested asset directory.
prepare_directory() {
    mkdir -p -- "$1"
    prepared="$(cd -- "$1" && pwd -P)"
    case "$prepared/" in
        "$repository/"*) die 'Destination must be outside the source repository.' ;;
    esac
}

install_item() {
    local source="$1" target="$2"
    # --force must never remove an ancestor of this checkout.
    case "$repository/" in
        "$target/"*) die "Destination would overwrite the source: $target" ;;
    esac
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ "$force" = false ]; then
            printf 'Skipped %s (already exists; use --force to replace).\n' "$target"
            return
        fi
        rm -rf -- "$target"
    fi
    cp -R -- "$source" "$target"
    printf 'Installed %s\n' "$target"
}

# Merge assets by file so unrelated personal agents and hooks survive updates.
install_assets() {
    local source="$1" target="$2" entry name
    prepare_directory "$target"
    target="$prepared"
    [ -d "$source" ] || return 0
    for entry in "$source"/* "$source"/.[!.]* "$source"/..?*; do
        [ -e "$entry" ] || [ -L "$entry" ] || continue
        name="${entry##*/}"
        [ "$name" != .gitkeep ] || continue
        if [ -d "$entry" ] && [ ! -L "$entry" ]; then
            install_assets "$entry" "$target/$name"
        else
            install_item "$entry" "$target/$name"
        fi
    done
}

for tool in "${tools[@]}"; do
    case "$tool" in
        codex)
            config_root="${CODEX_HOME:-${HOME:?HOME must be set}/.codex}"
            skills_destination="$HOME/.agents/skills" ;;
        claude)
            config_root="${CLAUDE_CONFIG_DIR:-${HOME:?HOME must be set}/.claude}"
            skills_destination="$config_root/skills" ;;
        opencode)
            config_root="${XDG_CONFIG_HOME:-${HOME:?HOME must be set}/.config}/opencode"
            skills_destination="$config_root/skills" ;;
        qwen)
            config_root="${HOME:?HOME must be set}/.qwen"
            skills_destination="$config_root/skills" ;;
    esac
    if [ -n "$destination" ]; then
        skills_destination="$destination"
    fi
    printf 'Installing for %s\n' "$tool"
    prepare_directory "$skills_destination"
    skills_destination="$prepared"
    if [ -n "$destination" ]; then
        config_root="$(dirname -- "$skills_destination")"
    fi
    for skill in "${skills[@]}"; do
        install_item "$source_root/$skill" "$skills_destination/$skill"
    done
    install_assets "$repository/agents/$tool" "$config_root/agents"
    install_assets "$repository/hooks/$tool" "$config_root/hooks"
done
printf 'Done. Hook assets require registration in the selected tool configuration.\n'
