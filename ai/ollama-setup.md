# Ollama Setup

Status: stale. Fedora local serving moved to llama.cpp on `http://fedora:8080/v1` with provider/model id `fedora/qwen3.6:27b`. This file is retained as migration history for the old Ollama setup.

The current Fedora command is `llm-serve`, which defaults to `unsloth/Qwen3.6-27B-GGUF`, `Qwen3.6-27B-UD-Q4_K_XL.gguf`, 128K context, and port 8080.

## Old Ollama Setup

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
