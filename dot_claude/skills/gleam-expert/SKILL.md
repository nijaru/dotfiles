---
name: gleam-expert
description: Use when needing idiomatic, high-performance Gleam (v1.x) guidance for type-safe functional programming on Erlang or JavaScript targets.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# Gleam Expert (v1.x)

## 🎯 Core Mandates

- **Explicit over implicit.** No hidden control flow, no exceptions, no null. Every edge case is in the type.
- **Custom types are everything.** Enums, structs, and tagged unions are all `type`. Model the domain; let the compiler enforce it.
- **Pipeline-first.** `|>` passes to the **first** argument (same as Elixir). To pipe to a different position, use a capture with `_` as the slot: `string.append("prefix", _)` or an anonymous function.
- **`use` for Result chains.** Desugar callbacks; don't nest `case` pyramids.
- **No function-head pattern matching.** All branching lives in `case` expressions inside the body.

## 🚫 Prohibited Patterns

- **DO NOT** write multiple function clauses — Gleam has one function body per name.
- **DO NOT** use `:atoms` — use custom type variants (`PascalCase` constructors) instead.
- **DO NOT** mix `Int` and `Float` arithmetic — float operators are `+.` `-.` `*.` `/.`; no implicit coercion.
- **DO NOT** assume `Option`/`Some`/`None` are in scope — they require `import gleam/option.{type Option, Some, None}`.
- **DO NOT** use `panic`/`todo`/`let assert` for recoverable errors — reserve them for programmer errors and impossible states.
- **DO NOT** string-interpolate with `#{}` — use `<>` for concatenation or `string.concat`/`string.join`.
- **DO NOT** write OTP actors for JavaScript targets — `gleam_otp` is Erlang-only.

## 🛠️ Technical Standards

### 1. Types & Pattern Matching

- **Custom types:** `pub opaque type` for domain types where constructors should be private. The only encapsulation mechanism.
- **Exhaustive `case`:** The compiler enforces it. Use guards (`if`) and alternative patterns (`a | b`) to stay DRY.
- **Useful patterns:** string prefix (`"https://" <> rest`), list spread (`[head, ..tail]`), tuple (`#(a, b)`), field shorthand (`name:` binds to `name`).
- **`let assert`** for infallible patterns that should panic if violated — the compiler warns if it's provably redundant.

### 2. Error Handling

- **`Result(ok, error)` everywhere.** Chain with `use`:
  ```gleam
  use user <- result.try(fetch_user(id))
  use token <- result.try(generate_token(user))
  Ok(token)
  ```
- **Key functions:** `result.try` (flatMap), `result.map`, `result.map_error`, `result.unwrap`, `result.all`.
- **`Option` bridge:** `option.from_result`, `option.to_result`.

### 3. Functions & Modules

- **Labeled arguments** improve call-site clarity and allow any order: `fn greet(name name: String)`.
- **Captures** for partial application: `list.map(items, int.add(_, 1))`.
- **One module per file.** Module name = file path from `src/` with `/` separators.
- **Imports:** qualified by default; unqualified for frequently used constructors only.

### 4. OTP (Erlang target only)

- Use `gleam_otp` + `gleam_erlang` packages.
- **Actors:** `actor.new(state) |> actor.on_message(handler) |> actor.start`.
- **Handler** returns `actor.continue(new_state)` or `actor.stop(reason)`.
- **`Subject(Msg)`** over raw `Pid` — typed mailbox reference.
- **Supervisors:** `static_supervisor` for fixed children, `factory_supervisor` for dynamic.

### 5. Multi-Target

- Isolate target-specific code with `@target(erlang)` / `@target(javascript)` attributes.
- JS FFI: relative `.mjs` path + exported function name. Erlang FFI: module atom + function atom.
- Elixir modules need `"Elixir.ModuleName"` atom prefix in FFI.
- Enable TypeScript declarations in `gleam.toml`: `[javascript] typescript_declarations = true`.

### 6. Naming & Style

- **Everything `snake_case`** — variables, functions, modules, fields.
- **`PascalCase`** for type names and variant constructors only.
- **Predicates** use `is_` prefix: `is_empty`, `is_some`, `is_none` (no `?` suffix — that's Elixir).
- Always run `gleam format` before committing.

## 🏗️ Tooling

| Task           | Command                                     |
| :------------- | :------------------------------------------ |
| New project    | `gleam new`                                 |
| Build          | `gleam build [--target erlang\|javascript]` |
| Run            | `gleam run [--runtime nodejs\|deno\|bun]`   |
| Test           | `gleam test`                                |
| Format         | `gleam format`                              |
| Add package    | `gleam add <package>`                       |
| Check outdated | `gleam deps outdated`                       |
| Publish        | `gleam publish`                             |

- **Testing:** `gleeunit`. Test functions must end with `_test`. Use `should.equal`, `should.be_ok`, `should.be_error`.
- **Debugging:** `io.debug(value)` prints any value and returns it unchanged — safe to insert mid-pipeline.
- **REPL:** None. Use `gleam run` with a scratch `main`.
- **Packages:** Hex (shared with Elixir/Erlang). Lock file: `manifest.toml`.
