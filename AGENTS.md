# System Status & Blueprint

## Current State

- **OS:** macOS (Tahoe) + Fedora 41 (Dual-boot)
- **Repo:** Private

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

### 5. Local LLM Serving

`llm-serve` starts an OpenAI-compatible server on port 8080 using mlx-lm (Mac) or vLLM (Fedora).

- **Mac model:** `~/.lmstudio/models/mlx-community/Qwen3.5-27B-Claude-4.6-Opus-Distilled-MLX-4bit`
- **Fedora model:** `cyankiwi/GLM-4.7-Flash-AWQ-4bit` via vLLM
- **Endpoint:** `http://localhost:8080/v1`

Agent integrations (all point at port 8080):

| Agent    | Config location                     | How to select              |
| -------- | ----------------------------------- | -------------------------- |
| pi       | `~/.pi/agent/models.json`           | Model picker (`local` provider) |
| opencode | `dot_config/opencode/opencode.json` | Model picker               |
| droid    | `dot_factory/settings.json`         | `/model` selector          |
| crush    | `OPENAI_BASE_URL` env var           | Set before launch          |

`pi-local` and `pi-fedora` functions are convenience wrappers for `--provider local/fedora`.

### 7. AI CLI Skills

Skills are symlinked from `~/.claude/skills/` to Gemini, Codex, and Pi via chezmoi. Canonical shared set includes `hf-cli` (Hugging Face CLI), `huggingface-datasets`, `huggingface-llm-trainer`, `systems-expert` (High-Performance Engineering), etc. See `ai/skills-sync.md`.

### 6. Shell

Fish (primary) + Nushell (maintained in parallel). Starship prompt on both. Tide installed but inactive.

**Nushell sync rule:** When adding fish functions, abbrs, or aliases, mirror them in `dot_config/nushell/config.nu`. Fish functions → nushell `def`/`def --env`. Fish abbrs/aliases → nushell `alias`. Keep git aliases, PATH, env vars, and tool integrations in sync across both shells.

---

## Chezmoi Workflow

Edit destination files directly, then sync back to source:

```bash
chezmoi add ~/.config/foo          # sync destination → source
chezmoi diff                       # preview pending changes
chezmoi apply --force              # apply source → destination (for pulling updates)
chezmoi re-add                     # re-sync all tracked destinations to source
```

**Key paths:** Source is `~/.local/share/chezmoi/`. Destination is `~/`. Prefix mapping: `dot_` → `.`, `executable_` → sets +x.

## Managing API Keys

To update API keys, follow these steps in the repo root:

1. **Create the plaintext secrets file:** `zed .chezmoidata.yaml`
2. **Paste and update your keys**
3. **Encrypt and Apply:**
   `age --encrypt -r <public-key> .chezmoidata.yaml > .chezmoidata.yaml.age && chezmoi apply --force && rm .chezmoidata.yaml`
