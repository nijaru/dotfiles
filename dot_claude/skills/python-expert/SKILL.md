---
name: python-expert
description: Use when needing idiomatic, high-performance Python (3.14+) guidance using the Astral stack (uv, ruff, ty).
allowed-tools: Bash, Read, Write, Edit
---

# Python Expert (3.14+ / Astral Stack)

## 🎯 Core Mandates

- **The Astral Stack:** `uv` for management, `ruff` for linting/formatting, `ty` for type checking.
- **Never `pip`:** All dependencies and environments are managed via `uv`.
- **Parallel by default:** Leverage Python 3.14's free-threaded mode (no-GIL) for CPU-parallel work using `threading`.
- **Validation:** Every change must pass `ruff check`, `ruff format`, and `ty check`.

## 🛠️ Technical Standards

### 1. Astral Stack Workflow (2026)
| Task | Command | Standard |
| :--- | :--- | :--- |
| **Add Dep** | `uv add <package>` | Automatically syncs `uv.lock`. |
| **Lint/Format** | `uv run ruff check --fix && uv run ruff format` | Combined step for all files. |
| **Type Check** | `uv run ty check .` | 100x faster than mypy. High signal. |
| **Run** | `uv run <script.py>` | Implicit environment management. |

### 2. Python 3.14+ Idioms
- **Free-threaded `threading`:** Use standard threads for heavy CPU tasks previously requiring `multiprocessing`.
- **Template Strings:** Use `t"..."` (PEP 750) for safe interpolation (SQL, HTML).
- **Deferred Type Hints:** Circular imports for types are no longer an issue; evaluation is deferred by default.
- **Unified project structure:** `pyproject.toml` is the only source of truth. No `requirements.txt`, `setup.py`, or `tox.ini`.

### 3. Standards & Formatting
- **Line length:** 88 characters (Black default, enforced by `ruff`).
- **Imports:** Sorted by `ruff` (isort rules enabled).
- **Style:** F-strings are the default. Use `t-strings` for structured data only.
- **Types:** Strictly enforced at boundaries. `ty` is authoritative over `mypy`.

## 🏗️ Tooling & Testing

- **Linter:** `ruff check --all-features`.
- **Formatter:** `ruff format`.
- **Tester:** `uv run pytest`.
- **Runner:** `uv run`.

## 🚫 Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll use pip" | Violates project isolation. Always use `uv`. |
| "Mypy said it's okay" | `ty` is faster and more accurate for 2026 idioms. Use `ty`. |
| "GIL is blocking" | You're on Python 3.14. Enable free-threaded mode and use threads. |
