#!/bin/sh
set -eu

repo=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)

install_link() {
    source=$1 target=$2
    [ "$source" = "$target" ] && return
    mkdir -p "$(dirname "$target")"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        return
    fi
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -f "$target"
    fi
    ln -s "$source" "$target"
    printf 'Installed %s\n' "$target"
}

install_skills() {
    dest=$1
    for source in "$repo"/skills/*; do
        [ -f "$source/SKILL.md" ] || continue
        install_link "$source" "$dest/$(basename "$source")"
    done
}

install_agents() {
    dest=$1 extension=$2
    for source in "$repo"/agents/*.$extension; do
        [ -f "$source" ] || continue
        install_link "$source" "$dest/$(basename "$source")"
    done
}

[ "$#" -gt 0 ] || set -- pi codex claude
for platform do
    case $platform in
        pi|codex|claude) ;;
        *) printf 'Usage: %s [pi|codex|claude ...]\n' "$0" >&2; exit 2 ;;
    esac
done
for platform do
    case $platform in
        pi)
            install_agents "$HOME/.pi/agent/agents" md
            install_skills "$HOME/.pi/agent/skills"
            ;;
        codex)
            install_agents "$HOME/.codex/agents" toml
            install_skills "$HOME/.agents/skills"
            ;;
        claude)
            install_agents "$HOME/.claude/agents" md
            install_skills "$HOME/.claude/skills"
            ;;
    esac
done
