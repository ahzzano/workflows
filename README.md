# General Workflows

Install the agents and skills in this repository for Pi, Codex CLI, and Claude Code:

```sh
./install.sh                 # all three
./install.sh pi codex claude # or choose any subset
```

The installer symlinks repository files into your user directories. It can be rerun after adding skills; it leaves existing files or different links untouched. Keep this checkout in place for the links to work.

| Tool | Agents | Skills |
| --- | --- | --- |
| Pi | `~/.pi/agent/agents/*.md` | `~/.pi/agent/skills/` |
| Codex CLI | `~/.codex/agents/*.toml` | `~/.agents/skills/` |
| Claude Code | `~/.claude/agents/*.md` | `~/.claude/skills/` |

Codex requires TOML agent definitions, so `agents/researcher.toml` is its equivalent of the Markdown agent. If this repository is already checked out at `~/.agents`, its skills are already at the Codex skills path.

Run `sh tests/install.sh` to check isolated installation, repeatability, and collision handling.
