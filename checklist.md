# Gemma 4 + Ollama Setup Checklist

## Status

- [x] Config updated: pi, opencode, droid (ollama + ollama-fedora providers)
- [x] llm-serve removed, committed

---

## Mac

- [ ] Install ollama 0.20.0-rc0 (required for Gemma 4 — needs SentencePiece BPE tokenizer)
      Download: https://github.com/ollama/ollama/releases/tag/v0.20.0-rc0
- [ ] Pull model: `ollama pull gemma4:26b`
- [ ] Apply chezmoi: `chezmoi apply --force`
- [ ] Test: `pi-local` → model picker → gemma4

---

## Fedora (SSH headless)

### Install / Update Ollama

- [ ] Update ollama to 0.20.0-rc0 (required for Gemma 4)
- [ ] Verify: `ollama --version`

### Configure systemd

- [ ] Write /etc/systemd/system/ollama.service.d/override.conf:
      `     [Service]
    Environment="OLLAMA_HOST=0.0.0.0:11434"
    Environment="OLLAMA_FLASH_ATTENTION=1"
    Environment="OLLAMA_KV_CACHE_TYPE=q4_0"
    `
      q4_0 = 4-bit KV cache (4x smaller than fp16, minimal quality loss for agentic use).
      Needed to fit large context on 4090 (~4GB free after loading 31b).
- [ ] Reload + restart: `sudo systemctl daemon-reload && sudo systemctl restart ollama`
- [ ] Verify listening on 0.0.0.0: `ss -tlnp | grep 11434`

### Pull + configure context

- [ ] Pull: `ollama pull gemma4:31b` (~20GB)
- [ ] Create 128K context model (try first):
      `     printf 'FROM gemma4:31b\nPARAMETER num_ctx 131072' | ollama create gemma4:31b-128k -f -
    `
      If OOM, fall back to 64K:
      `     printf 'FROM gemma4:31b\nPARAMETER num_ctx 65536' | ollama create gemma4:31b-64k -f -
    `
      Note: 128K likely requires ~10-12GB KV cache even at q4_0. May not fit with 31b.
      Consider gemma4:26b (18GB, 6GB free) for better context headroom.
- [ ] Test: `ollama run gemma4:31b-128k` — send a short message, check no OOM in `ollama logs`

### Firewall (if needed)

- [ ] Tailscale traffic usually bypasses firewall, but if unreachable from Mac:
      `sudo firewall-cmd --add-port=11434/tcp --zone=trusted`

---

## Verify end-to-end from Mac

- [ ] `curl http://fedora:11434/v1/models` — should list gemma4 models
- [ ] `pi-fedora` → model picker → gemma4
- [ ] opencode model picker → ollama-fedora provider

---

## Update chezmoi model IDs (after context model names confirmed)

- [ ] Update dot_pi/agent/settings.json and dot_config/opencode/opencode.json
      to use final model name (e.g. `gemma4:31b-128k` or `gemma4:31b-64k`)
- [ ] Commit + push
