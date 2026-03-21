---
name: fish-expert
description: Use for managing the Fish/Nushell dual-shell environment, maintaining shell configuration, and mirroring functions/aliases.
allowed-tools: Bash, Read, Write, Edit
---

# Fish/Nushell Dual-Shell Maintenance

## 🎯 Core Mandates

- **The Sync Rule:** Any change to `config.fish`, Fish functions, abbreviations, or aliases MUST be mirrored in `config.nu`.
- **Fish first:** Author in Fish, then translate to Nushell.
- **Starship configuration:** Keep `starship.toml` unified across both shells.

## 🛠️ Technical Standards

### 1. Mirroring Strategy
| Fish Concept | Nushell Mirror |
| :--- | :--- |
| **`function`** | `def` or `def --env` |
| **`abbr` / `alias`** | `alias` |
| **`set -gx`** | `$env.<NAME> = "..."` |
| **`PATH`** | `$env.PATH` (ensure it's updated correctly) |

### 2. Fish Workflow
- Use `functions -n` to list all user functions.
- Use `abbr -l` to list all abbreviations.
- Edit `dot_config/fish/config.fish` and `dot_config/fish/functions/`.

### 3. Nushell Workflow
- Edit `dot_config/nushell/config.nu`.
- Ensure custom commands are properly exported.
- Test with `nu -c "your-command"`.

## 🚫 Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll sync later" | Drift between shells causes confusing runtime bugs. Sync now. |
| "It's just an alias" | Even an alias can change how you interact with the system. Sync it. |
| "I don't use Nushell" | The system mandates parallel maintenance. Follow the rule. |
