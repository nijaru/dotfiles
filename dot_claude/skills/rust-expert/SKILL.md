---
name: rust-expert
description: Use when needing idiomatic, high-performance Rust (Edition 2024, 1.93+) guidance for systems logic, async services, or performance-critical libraries.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# Rust Expert (Edition 2024 / 1.93+)

## Core Mandates

- **Edition 2024:** All new crates use `edition = "2024"` in `Cargo.toml`. Migrate with `cargo fix --edition`.
- **Borrow before clone:** Prefer `&str`/`&[T]`/`&T` over owned types at API boundaries. `.clone()` to fix borrow errors is a code smell — rethink ownership.
- **Error strategy:** `thiserror` for libraries (typed errors), `anyhow` for applications (context-rich chains). Never `Box<dyn Error>` in library APIs.
- **Async routing:** `tokio` for network I/O, `rayon` for CPU-parallel work, sync stdlib for file I/O (async file I/O rarely improves throughput).
- **Strong types:** Newtypes and enums over `String`/`i32` for domain concepts. Parse at boundaries, use types internally.

## Prohibited Patterns

- **NO** `.unwrap()` in library code — use `?`, `expect("reason")`, or proper error handling.
- **NO** `Box<dyn Error>` in library return types — use `thiserror` enums.
- **NO** `super::` paths — use `crate::` (clearer, refactor-stable).
- **NO** `pub use` re-exports unless intentionally part of the public API surface.
- **NO** `lazy_static!` or global `OnceLock`/`Mutex` state — pass context explicitly.
- **NO** `unsafe` block without a `// SAFETY:` comment explaining the invariants.
- **NO** bare `extern "C"` blocks — use `unsafe extern "C"` (Edition 2024 requirement).
- **NO** `Captures<>` trick for RPIT lifetimes — use `use<'a, T>` precise capturing or rely on 2024 defaults.
- **NO** `std::sync::Mutex` for high-contention paths — prefer `parking_lot::Mutex` or restructure with channels.
- **NO** `#[bench]` attribute — hard error since 1.88; use `criterion` or `divan`.

## Technical Standards

### 1. Edition 2024 Changes

- **RPIT lifetime capture:** `impl Trait` in return position now captures all in-scope lifetimes by default. Use `impl Trait + use<'a, T>` (stable 1.82) to restrict explicitly.
  ```rust
  // 2024: captures 'a implicitly — may require use<> to be more restrictive
  fn iter<'a>(&'a self) -> impl Iterator<Item = &str> { ... }
  fn iter<'a>(&'a self) -> impl Iterator<Item = &str> + use<'a> { ... } // explicit
  ```
- **`unsafe extern` blocks:** All `extern` blocks with unsafe items now require `unsafe extern "ABI" {}`.
- **`unsafe_op_in_unsafe_fn`:** Unsafe operations inside `unsafe fn` require their own `unsafe {}` block — functions declare preconditions, blocks discharge them.
- **`gen` is reserved:** Cannot be used as an identifier (reserved for future generator syntax).
- **`let` chains (1.88, Edition 2024):** Mix `let` bindings and boolean guards freely.
  ```rust
  if let Some(x) = map.get(&key) && x.is_valid() && let Some(y) = x.child() { ... }
  ```

### 2. Type System & Ergonomics

- **Async closures (1.85):** `async || { ... }` stable — use instead of `|| async { ... }` when you need `AsyncFn` bounds.
- **Trait object upcasting (1.86):** `&dyn Derived` coerces to `&dyn Base` — no manual wrapper needed.
  ```rust
  fn needs_base(x: &dyn Base) { ... }
  needs_base(derived_ref); // works in 1.86+
  ```
- **Precise capturing (1.82):** `impl Trait + use<'a, T>` specifies exactly which params the opaque type may use. Prefer over `+ '_` outlives trick.
- **`#[target_feature]` on safe fns (1.86):** Safe functions can now be annotated — call sites still require `unsafe` if calling without the feature active.

### 3. Performance & Systems

- **SIMD:** Use `std::arch` intrinsics or `std::simd` (portable SIMD, still nightly). Target-specific: enable with `#[target_feature(enable = "avx2")]` on safe functions.
- **Strict arithmetic (1.89):** `a.strict_add(b)`, `strict_mul`, etc. — panics on overflow in all build modes. Use for invariant enforcement without `checked_*` verbosity.
- **Carrying ops (1.89):** `a.carrying_add(b, carry)`, `borrowing_sub` — for multi-precision arithmetic without inline assembly.
- **`hint::select_unpredictable` (1.87):** Timing-safe conditional selection — avoids branch predictor speculation, useful in crypto code.
- **Slice chunks (1.88):** `slice.as_chunks::<N>()` returns `(&[[T; N]], &[T])` — exact-size chunks without bounds checks in the loop.
- **`MaybeUninit` slices (1.93):** `uninit_slice.write_copy_of_slice(&src)` and `assume_init_ref()` for safe incremental initialization.

### 4. I/O & Async

- **Anonymous pipes (1.87):** `let (reader, writer) = io::pipe()?` — pairs with `std::process::Command` for subprocess I/O without threads.
- **File locking (1.90):** `file.lock()`, `file.try_lock_shared()`, `file.unlock()` — cross-platform advisory locks.
- **`Duration` helpers (1.90):** `Duration::from_mins(5)`, `Duration::from_hours(2)`.
- **Path helpers (1.90):** `path.file_prefix()` (stem without all extensions), `buf.add_extension("gz")` (appends without replacing).

### 5. Error Handling

- `thiserror`: derive `Error` with `#[error("...")]` and `#[from]` for automatic `From` impls.
- `anyhow`: `.context("what you were doing")` on every `?` at call sites. Use `anyhow::bail!` and `ensure!` macros.
- Chain errors for diagnostics; let them propagate rather than catching to log and re-throw.

## Tooling

- **Test runner:** `cargo nextest` — parallel, faster, better output than `cargo test`.
- **Linting:** `cargo clippy --all-features --all-targets -- -D warnings` in CI.
- **Auditing:** `cargo deny check` for license/security/duplicate dep policy.
- **Dead deps:** `cargo machete` to find unused dependencies.
- **UB detection:** `cargo miri test` before any `unsafe` PR.
- **Benchmarks:** `criterion` (mature, HTML reports) or `divan` (simpler setup). Never `#[bench]`.
- **Edition migration:** `cargo fix --edition && cargo fix --edition-idioms` then review diff.
