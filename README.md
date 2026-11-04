# General Workflows

Symlink this repository's `skills/`, `agents/`, and `AGENTS.md` into Pi, OMP, Codex CLI, and Claude Code:

```sh
./install.sh                     # all four
./install.sh pi omp codex claude # or choose any subset
```

On Windows, run from PowerShell:

```powershell
.\install.ps1                               # all four
.\install.ps1 -Platform pi,omp,codex,claude # or choose any subset
```

Windows symlinks require Developer Mode or an elevated PowerShell session. Each path is a single symlink to this checkout, so new skills and agents appear without rerunning. Existing files and different links are replaced; a real directory is replaced only if it contains nothing but symlinks (the old per-file layout), otherwise the installer refuses. Keep this checkout in place.

| Tool | Skills | Agents | Instructions |
| --- | --- | --- | --- |
| Pi | `~/.pi/agent/skills` | `~/.pi/agent/agents` | `~/.pi/agent/AGENTS.md` |
| OMP | `~/.omp/agent/skills` | `~/.omp/agent/agents` | `~/.omp/agent/AGENTS.md` |
| Codex CLI | `~/.agents/skills` | `~/.codex/agents` | `~/.codex/AGENTS.md` |
| Claude Code | `~/.claude/skills` | `~/.claude/agents` | `~/.claude/CLAUDE.md` (Claude reads `CLAUDE.md`, so it links to `AGENTS.md`) |

`agents/` holds both `.md` and `.toml` definitions, and every tool now sees both.

Codex uses TOML agent definitions. All five roles (`auditor`, `planner`, `researcher`, `scout`, and `worker`) have equivalents in `agents/*.toml`; run `./install.sh codex` after adding them. The auditor, planner, and scout are instructed not to edit files. All roles inherit the parent session's sandbox; these instructions are not a separate permissions boundary. Models are inherited from the parent session, and delegation or browsing is used only when available. If this repository is already checked out at `~/.agents`, its skills are already at the Codex skills path. Codex discovers the symlinked skill directories; invoke the review skill explicitly with `$thermo-nuclear-code-quality-review` (its `agents/openai.yaml` disables implicit invocation, matching the Claude skill setting).

Run `sh tests/install.sh` (or `.\tests\install.ps1` on Windows) to check installation of all five agents on each platform, repeatability, and collision handling in an isolated home directory.
