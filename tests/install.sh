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
[ -f "$HOME/.agents/skills/thermo-nuclear-code-quality-review/agents/openai.yaml" ]
grep -q 'allow_implicit_invocation: false' "$HOME/.agents/skills/thermo-nuclear-code-quality-review/agents/openai.yaml"

sh "$repo/install.sh" >/dev/null
rm "$HOME/.claude/agents/researcher.md"
printf 'outdated\n' > "$HOME/.claude/agents/researcher.md"
rm "$HOME/.pi/agent/agents/researcher.md"
ln -s "$HOME/.claude/agents/researcher.md" "$HOME/.pi/agent/agents/researcher.md"
rm "$HOME/.claude/skills/tdd"
mkdir "$HOME/.claude/skills/tdd"
if sh "$repo/install.sh" claude >/dev/null 2>&1; then exit 1; fi
rmdir "$HOME/.claude/skills/tdd"
sh "$repo/install.sh" pi claude >/dev/null
[ "$(readlink "$HOME/.claude/agents/researcher.md")" = "$repo/agents/researcher.md" ]
[ "$(readlink "$HOME/.pi/agent/agents/researcher.md")" = "$repo/agents/researcher.md" ]
[ "$(readlink "$HOME/.claude/skills/tdd")" = "$repo/skills/tdd" ]
if sh "$repo/install.sh" invalid > /dev/null 2>&1; then exit 1; fi
printf 'Installer smoke test passed\n'
