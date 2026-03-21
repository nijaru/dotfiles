---
name: mise
description: Use for runtime and tool version management, project-local environments, and reshimming.
allowed-tools: Bash, Read
---

# mise (Tool Version Manager)

## 🎯 Core Mandates

- **Source of Truth:** Use `mise ls` to identify active tool versions.
- **Project Specific:** Use `mise use` within a project directory to pin versions.
- **Reshimming:** Always run `mise reshim` after adding new global binaries via `bun`, `cargo`, or `go`.

## 🛠️ Technical Standards

### 1. Version Management
| Task | Command | Purpose |
| :--- | :--- | :--- |
| **Check Active** | `mise ls` | List active runtimes and versions. |
| **Pin Version** | `mise use <tool>@<version>` | Set local project version. |
| **Global Set** | `mise use -g <tool>@<version>` | Set default system version. |
| **Install** | `mise install <tool>` | Fetch and install a new version. |

### 2. Operational Flow
- **Avoid manual exports:** Mise handles path management. Use `mise env` to see the current environment.
- **Reshimming:** Essential for ensuring newly installed tools are correctly linked in the PATH.
- **Settings:** Configuration is managed in `~/.config/mise/config.toml`.

## 🚫 Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll use the system python" | Violates project isolation. Use `mise`. |
| "It's already in the path" | Stale shims can cause the wrong binary to execute. `mise reshim`. |
| "I'll use asdf/pyenv" | Mise replaces these; don't mix them. |
