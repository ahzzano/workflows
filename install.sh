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
    if [ -d "$target" ] && [ ! -L "$target" ]; then
        # Only the old per-file layout (symlinks) may be replaced.
        if [ -n "$(find "$target" -mindepth 1 ! -type l)" ]; then
            printf 'Refusing to replace directory: %s\n' "$target" >&2
            exit 1
        fi
        find "$target" -mindepth 1 -delete
        rmdir "$target"
    elif [ -e "$target" ] || [ -L "$target" ]; then
        rm -f "$target"
    fi
    ln -s "$source" "$target"
    printf 'Installed %s\n' "$target"
}

# install_platform <config dir> <instructions filename> [skills dir]
install_platform() {
    install_link "$repo/skills" "${3:-$1/skills}"
    install_link "$repo/agents" "$1/agents"
    install_link "$repo/AGENTS.md" "$1/$2"
}

[ "$#" -gt 0 ] || set -- pi omp codex claude
for platform do
    case $platform in
        pi|omp|codex|claude) ;;
        *) printf 'Usage: %s [pi|omp|codex|claude ...]\n' "$0" >&2; exit 2 ;;
    esac
done
for platform do
    case $platform in
        pi) install_platform "$HOME/.pi/agent" AGENTS.md ;;
        omp) install_platform "$HOME/.omp/agent" AGENTS.md ;;
        codex) install_platform "$HOME/.codex" AGENTS.md "$HOME/.agents/skills" ;;
        claude) install_platform "$HOME/.claude" CLAUDE.md ;;
    esac
done
