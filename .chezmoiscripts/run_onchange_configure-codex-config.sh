#!/usr/bin/env bash
set -euo pipefail

config="$HOME/.codex/config.toml"
mkdir -p "$(dirname "$config")"

python3 - "$config" <<'PY'
from __future__ import annotations

import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text() if path.exists() else "# Codex CLI Configuration\n"
lines = text.splitlines()


def toml_string(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def set_top_level(key: str, value: str) -> None:
    pattern = re.compile(rf"^{re.escape(key)}\s*=")
    replacement = f"{key} = {value}"
    for index, line in enumerate(lines):
        if line.startswith("["):
            break
        if pattern.match(line):
            lines[index] = replacement
            return
    insert_at = 0
    while insert_at < len(lines) and (lines[insert_at].startswith("#") or lines[insert_at] == ""):
        insert_at += 1
    lines.insert(insert_at, replacement)


def ensure_section(name: str, values: dict[str, str]) -> None:
    header = f"[{name}]"
    start = None
    for index, line in enumerate(lines):
        if line.strip() == header:
            start = index
            break

    if start is None:
        if lines and lines[-1] != "":
            lines.append("")
        lines.append(header)
        for key, value in values.items():
            lines.append(f"{key} = {value}")
        return

    end = start + 1
    while end < len(lines) and not lines[end].startswith("["):
        end += 1

    existing = {key: False for key in values}
    for index in range(start + 1, end):
        for key, value in values.items():
            if re.match(rf"^{re.escape(key)}\s*=", lines[index]):
                lines[index] = f"{key} = {value}"
                existing[key] = True

    insert_at = end
    for key, value in values.items():
        if not existing[key]:
            lines.insert(insert_at, f"{key} = {value}")
            insert_at += 1


set_top_level("model", toml_string("gpt-5.5"))
set_top_level("model_reasoning_effort", toml_string("medium"))
set_top_level("personality", toml_string("pragmatic"))
set_top_level("project_doc_fallback_filenames", '["AGENTS.md", "CLAUDE.md", "README.md"]')
set_top_level("approval_policy", toml_string("never"))
set_top_level("sandbox_mode", toml_string("danger-full-access"))

ensure_section("mcp_servers.context7", {
    "command": toml_string("npx"),
    "args": '["-y", "@upstash/context7-mcp"]',
})
ensure_section("mcp_servers.exa", {
    "command": toml_string("npx"),
    "args": '["-y", "exa-mcp-server", "-e", "EXA_API_KEY"]',
})

for project in [
    "/Users/nick/github/nijaru/pacabot",
    "/Users/nick/github/omendb/omendb-mojo",
    "/Users/nick/.local/share/chezmoi",
]:
    ensure_section(f'projects."{project}"', {"trust_level": toml_string("trusted")})

path.write_text("\n".join(lines).rstrip() + "\n")
PY
