# Ollama Setup

Both machines run ollama on port 11434. Configs in chezmoi: pi, opencode, droid all point to `ollama` (local) and `ollama-fedora` (`http://fedora:11434/v1` via Tailscale).

## Mac

- Ollama app (0.20.0-rc0+ required for gemma4 — needs SentencePiece BPE tokenizer)
- MLX backend, 256K context set in app settings
- Models: `gemma4:26b`, `gemma4:31b`
- KV cache configured in app, no Modelfile needed

## Fedora (RTX 4090, 24GB VRAM)

- Ollama installed to `/usr/local/bin/ollama` via install.sh
- Model: `gemma4:31b-64k` (custom Modelfile, `num_ctx 65536`)
- 64K is the VRAM ceiling: 18.4GB weights + 2.4GB KV cache + 0.5GB compute = 21.3GB / 23.5GB available
- KV cache: q4_0 (4-bit), flash attention enabled

### Systemd service: `/etc/systemd/system/ollama.service`

Env vars must be inline in `[Service]` — drop-in override.conf was unreliable:

```ini
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_FLASH_ATTENTION=1"
Environment="OLLAMA_KV_CACHE_TYPE=q4_0"
```

### Gotchas

1. **Wrong ownership on install** — `sudo mkdir -p /usr/share/ollama && sudo chown -R ollama:ollama /usr/share/ollama`
2. **Drop-in override.conf unreliable** — add env vars directly to main service file
3. **Stale process holds port after restart** — `sudo pkill ollama && sudo systemctl restart ollama`
4. **Fish heredoc** — use `printf '...' > file` instead of `<< 'EOF'`
5. **install.sh pulls 0.19.0 instead of rc0** — manually replace binary:
   ```fish
   curl -L https://github.com/ollama/ollama/releases/download/v0.20.0-rc0/ollama-linux-amd64.tar.zst -o /tmp/ollama.tar.zst
   cd /tmp && tar -xf ollama.tar.zst
   sudo systemctl stop ollama
   sudo cp /tmp/bin/ollama /usr/local/bin/ollama
   sudo systemctl start ollama
   ```

### 64K context Modelfile

```fish
printf 'FROM gemma4:31b\nPARAMETER num_ctx 65536\n' > /tmp/Modelfile
ollama create gemma4:31b-64k -f /tmp/Modelfile
```
