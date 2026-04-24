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

data["defaultProvider"] = "fedora"
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
data["defaultModel"] = "qwen3.6:27b"
data["quietStartup"] = True

providers = data.setdefault("providers", {})
providers.pop("ollama", None)
providers.pop("ollama-fedora", None)
providers["fedora"] = {
    "baseUrl": "http://fedora:8080/v1",
    "api": "openai-completions",
    "apiKey": "llama",
    "models": [{"id": "qwen3.6:27b", "contextWindow": 131072}],
}
providers.pop("llama-fedora", None)

path.write_text(json.dumps(data, indent=2) + "\n")
PY
