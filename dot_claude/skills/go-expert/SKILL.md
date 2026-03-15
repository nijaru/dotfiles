---
name: go-expert
description: Expert guidance for writing idiomatic, high-performance Go (v1.26). Use when implementing system-level logic, SIMD-accelerated algorithms, or memory-mapped storage engines.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# Go Expert (v1.26)

## 🎯 Core Mandates

- **Modernity:** Prioritize Go 1.26+ idioms. Treat pre-2024 patterns as technical debt.
- **Performance:** Optimize for "Green Tea" GC. Minimize allocations in hot paths using modern primitives.
- **Safety:** Use `os.Root` for all file operations to prevent path traversal.

## 🛠️ Technical Standards (Go 1.26)

### 1. Syntax & Core Language
- **No `interface{}`:** Use `any` exclusively.
- **Inline Pointers:** Use `new(T(value))` for inline pointer creation.
  - *Example:* `p := new(int(42))`
- **Recursive Generics:** Use recursive type constraints for linked structures.
  - `type Node[T Node[T]] interface { Next() T }`
- **Iterators:** Use `iter.Seq` and `iter.Seq2`. Prefer range-over-functions for custom sequences.
  - Signature: `func(yield func(V) bool) bool`

### 2. Modern Standard Library
- **Logging:** Use `log/slog` for structured logging.
- **Collections:** Use `slices` and `maps` packages for all generic operations (Sort, Contains, etc.).
- **JSON v2:** Use `encoding/json/v2`. Apply `omitzero` struct tags to reduce payload size.
- **FS Security:** Use `os.Root` to sandbox filesystem access (Go 1.24+).

### 3. Concurrency & Performance
- **Atomics:** Use generic types from `sync/atomic` (e.g., `atomic.Pointer[T]`).
- **Sync Testing:** Use `testing/synctest` for deterministic concurrent tests with virtual clocks.
- **Benchmarks:** Use `b.Loop()` for automatic timer management and to prevent compiler optimizations of loop bodies.
  ```go
  for b.Loop() {
      // implementation
  }
  ```

### 4. Error Handling
- **Type-Safe Unwrapping:** Use `errors.AsType[T](err)` (Go 1.26).
  ```go
  if e, ok := errors.AsType[*MyErr](err); ok { ... }
  ```
- **Wrapping:** Always use `fmt.Errorf("...: %w", err)`.

## 🚫 Prohibited Patterns

- **DO NOT** use `ioutil` (deprecated).
- **DO NOT** use `sort.Slice` (use `slices.Sort`).
- **DO NOT** use `reflect` where Generics or Iterators suffice.
- **DO NOT** use `context.TODO()` in tests (use `t.Context()`).
- **DO NOT** use `//go:build` with old syntax (use Go 1.17+ syntax).

## 🏗️ Tooling & Workspace
- **Modern Fix:** Use `go fix` to migrate legacy code to modern 1.26+ patterns.
- **Dependencies:** Use the `tool` directive in `go.mod` for dev tools (Go 1.24+).
- **Workspaces:** Default to `go.work` for multi-module development.
- **Formatting:** Use `golines --base-formatter gofumpt`.
- **Tidying:** Always run `go mod tidy` after changing dependencies.
- **Go Tool:** Use `go tool [package]` for running project-specific tools defined in `go.mod` (Go 1.24+).
