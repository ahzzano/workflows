#!/bin/sh
set -eu

repo=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd -P)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
HOME=$tmp; export HOME

(cd / && sh "$repo/install.sh" pi codex claude)
for target in \
    "$HOME/.pi/agent/agents/researcher.md" \
    "$HOME/.codex/agents/researcher.toml" \
    "$HOME/.claude/agents/researcher.md"; do
    [ -L "$target" ] && [ -f "$target" ]
done
for tool in .pi/agent .agents .claude; do
    for skill in "$repo"/skills/*; do
        [ -f "$skill/SKILL.md" ] || continue
        [ -L "$HOME/$tool/skills/$(basename "$skill")" ]
    done
done

sh "$repo/install.sh" >/dev/null
printf 'keep me\n' > "$HOME/.claude/agents/researcher.md".new
rm "$HOME/.claude/agents/researcher.md"
mv "$HOME/.claude/agents/researcher.md".new "$HOME/.claude/agents/researcher.md"
sh "$repo/install.sh" claude >/dev/null 2>&1
[ "$(cat "$HOME/.claude/agents/researcher.md")" = 'keep me' ]
if sh "$repo/install.sh" invalid > /dev/null 2>&1; then exit 1; fi
printf 'Installer smoke test passed\n'
