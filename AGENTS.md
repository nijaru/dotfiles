# System Status & Blueprint

## Current State
- **OS:** macOS (Tahoe) + Fedora 41 (Dual-boot)
- **Status:** Fully restored, optimized, and hardened. Repo set to **Private**.

## Core Setup (For Future Reference)

### 1. Secrets & Encryption
- **Tool:** `age` + `chezmoi`
- **Master Key:** Symlinked from `~/Library/Mobile Documents/com~apple~CloudDocs/Developer/age-keys.txt` to `~/.config/age/keys.txt`.
- **Encryption:** All secrets managed in `.chezmoidata.yaml.age`.

### 2. macOS Environment
- **Shell:** Fish (Default). Optimized for <30ms startup.
- **Terminal:** Ghostty. Config lives in `~/Library/Application Support/com.mitchellh.ghostty/config`.
- **Editor:** Zed (`EDITOR="zed"`, `VISUAL="zed --wait"`).
- **Associations:** `duti` sets Zed as default for `public.plain-text` and `public.data`.
- **Packages:** `Brewfile` is a whitelist. Run `brew bundle cleanup --force` to purge bloat.

### 3. Fedora Configuration
- **Secure Boot:** Enabled. NVIDIA drivers signed via MOK (`/etc/pki/akmods/certs/`).
- **Disk:** Auto-unlocks via TPM2 (PCRs 0,1,4,5,7).
- **Setup Script:** `~/restore_secure_boot.sh` (Staged on Fedora).

### 4. Development & Tooling
- **Task Tracking:** Use `tk` CLI (installed via `bun add -g @nijaru/tk`). Tasks in `.tasks/`.
- **Agent Management:** `update-agents` function optimized with Bun for fast, high-signal batch updates.
- **Bun Global:** Global binaries at `~/.cache/.bun/bin` (added to path via `paths.fish`).
- **Structure:** Repos at `~/github/<owner>/<repo>`. Use `ghc <repo>` to clone.

---

## Managing API Keys

To update API keys, follow these steps in the repo root:

1. **Create the plaintext secrets file:** `zed .chezmoidata.yaml`
2. **Paste and update your keys**
3. **Encrypt and Apply:**
   `age --encrypt -r <public-key> .chezmoidata.yaml > .chezmoidata.yaml.age && chezmoi apply --force && rm .chezmoidata.yaml`
