# General Workflows

Install the agents and skills in this repository for Pi, Codex CLI, and Claude Code:

```sh
./install.sh                 # all three
./install.sh pi codex claude # or choose any subset
```

On Windows, run from PowerShell:

```powershell
.\install.ps1                           # all three
.\install.ps1 -Platform pi,codex,claude # or choose any subset
```

Windows symlinks require Developer Mode or an elevated PowerShell session. The installer symlinks repository files into your user directories. Rerun it after adding agents or skills; it replaces existing files or different links with links to this checkout, so subsequent edits appear immediately. It does not replace directories. Keep this checkout in place for the links to work.

| Tool | Agents | Skills |
| --- | --- | --- |
| Pi | `~/.pi/agent/agents/*.md` | `~/.pi/agent/skills/` |
| Codex CLI | `~/.codex/agents/*.toml` | `~/.agents/skills/` |
| Claude Code | `~/.claude/agents/*.md` | `~/.claude/skills/` |

Codex uses TOML agent definitions. All five roles (`auditor`, `planner`, `researcher`, `scout`, and `worker`) have equivalents in `agents/*.toml`; run `./install.sh codex` after adding them. The auditor, planner, and scout are instructed not to edit files. All roles inherit the parent session's sandbox; these instructions are not a separate permissions boundary. Models are inherited from the parent session, and delegation or browsing is used only when available. If this repository is already checked out at `~/.agents`, its skills are already at the Codex skills path. Codex discovers the symlinked skill directories; invoke the review skill explicitly with `$thermo-nuclear-code-quality-review` (its `agents/openai.yaml` disables implicit invocation, matching the Claude skill setting).

Run `sh tests/install.sh` (or `.\tests\install.ps1` on Windows) to check installation of all five agents on each platform, repeatability, and collision handling in an isolated home directory.
