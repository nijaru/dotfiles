#!/usr/bin/env bash
set -euo pipefail

settings="$HOME/.pi/agent/settings.json"
mkdir -p "$(dirname "$settings")"

python3 - "$settings" <<'PY'
from __future__ import annotations

import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
if path.exists() and path.read_text().strip():
    data = json.loads(path.read_text())
else:
    data = {}

data["defaultProvider"] = "openrouter"
data["theme"] = "dark"
data["autoSave"] = True
data["editorPaddingX"] = 1
data["steeringMode"] = "all"
data["followUpMode"] = "all"
data["hideThinkingBlock"] = True
data["collapseChangelog"] = True
data["defaultThinkingLevel"] = "high"
data["skills"] = ["~/.agents/skills"]
data["packages"] = [
    "npm:pi-mcp-adapter",
    "npm:pi-subagents",
    "npm:pi-web-search",
    "npm:pi-messenger",
]
data["defaultModel"] = "moonshotai/kimi-k2.6"
data["quietStartup"] = True

providers = data.setdefault("providers", {})
providers["ollama"] = {
    "baseUrl": "http://localhost:11434/v1",
    "api": "openai-completions",
    "apiKey": "ollama",
    "models": [{"id": "qwen3.6:latest", "contextWindow": 262144}],
}
providers["ollama-fedora"] = {
    "baseUrl": "http://fedora:11434/v1",
    "api": "openai-completions",
    "apiKey": "ollama",
    "models": [{"id": "qwen3.6:27b", "contextWindow": 131072}],
}
providers["llama-fedora"] = {
    "baseUrl": "http://fedora:11435/v1",
    "api": "openai-completions",
    "apiKey": "llama",
    "models": [{"id": "qwen3.6:27b-llama", "contextWindow": 262144}],
}

path.write_text(json.dumps(data, indent=2) + "\n")
PY
