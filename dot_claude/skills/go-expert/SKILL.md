---
name: go-expert
description: Use when needing idiomatic, high-performance Go (v1.26) guidance for system-level logic, SIMD-accelerated algorithms, or memory-mapped storage engines.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# Go Expert (v1.26)

## 🎯 Core Mandates

- **Modernity:** Prioritize Go 1.26+ idioms. Treat pre-2024 patterns as technical debt.
- **Performance:** Green Tea GC is default (Go 1.26). Minimize allocations in hot paths.
- **Safety:** Use `os.Root` for all file operations to prevent path traversal.

## 🚫 Prohibited Patterns

- **DO NOT** use `ioutil` (deprecated — use `os`/`io` directly).
- **DO NOT** use `sort.Slice` (use `slices.Sort`).
- **DO NOT** use `interface{}` (use `any`).
- **DO NOT** use `reflect` where generics or iterators suffice.
- **DO NOT** use `context.TODO()` in tests (use `t.Context()`).
- **DO NOT** use `runtime.SetFinalizer` (use `runtime.AddCleanup` — Go 1.24, supports multiple cleanups, no cycle leaks).
- **DO NOT** use `//go:build` with old syntax (use Go 1.17+ syntax).
- **DO NOT** use `fmt.Sprintf("%s:%d", host, port)` for addresses — use `net.JoinHostPort` (IPv6 safe; `go vet hostport` catches this, Go 1.25).
- **DO NOT** call `sync.WaitGroup.Add` inside the goroutine being counted — call before `go` (`go vet waitgroup`, Go 1.25).
- **DO NOT** construct URLs with colons in the host (`http://host:80:80/`) — `net/url.Parse` rejects these (Go 1.26).

## 🛠️ Technical Standards

### 1. Syntax & Core Language

- **Inline Pointers:** `new(expr)` infers pointer type from expression (Go 1.26). Replaces `v := x; &v` patterns.
  - `new(true)` → `*bool` · `new(int32(n))` → `*int32` · `new(f())` → `*ReturnType`
- **Generic Type Aliases:** `type Set[T comparable] = map[T]struct{}` (Go 1.24).
- **Recursive Generics:** Type parameters may reference their own generic type (Go 1.26).
  - `type Node[T Node[T]] interface { Next() T }`
- **Iterators:** Use `iter.Seq` / `iter.Seq2` and range-over-functions (Go 1.23+).
  - `Seq[V any]` is `func(yield func(V) bool)` · `Seq2[K, V any]` is `func(yield func(K, V) bool)`
  - String/byte iteration: `strings.Lines(s)`, `strings.SplitSeq(s, sep)`, `bytes.FieldsSeq(b)` (Go 1.24)

### 2. Modern Standard Library

- **Logging:** Use `log/slog`. `NewMultiHandler` fans out to multiple handlers (Go 1.26). Use `LogAttrs()` over `Info()`/`Debug()` in hot paths — skips key-value boxing.
- **Collections:** Use `slices` and `maps` packages for all generic operations.
- **JSON:** Prefer `github.com/go-json-experiment/json` (v2) for new code — case-sensitive by default, `RejectUnknownMembers` option, functional options at call site, richer struct tags. API still evolving; pin your version. Also available as `encoding/json/v2` with `GOEXPERIMENT=jsonv2`.
  - `omitzero` struct tag available in **standard** `encoding/json` since Go 1.24 (no v2 required).
- **FS Security:** `os.Root` sandboxes all filesystem access including symlinks (Go 1.24). Methods mirror the `os` package.
- **Post-Quantum Crypto:** Use `crypto/hpke` for Hybrid Public Key Encryption (RFC 9180). `crypto/tls` enables `SecP256r1MLKEM768` by default (Go 1.26).
- **Signal Cause:** `os/signal.NotifyContext` cancels with cause — use `context.Cause(ctx)` to identify which signal fired (Go 1.26).
- **Weak References:** Use `weak.Pointer[T]` for memory-efficient caches and canonicalization maps (Go 1.24). Pair with `runtime.AddCleanup`.

### 3. Concurrency & Performance

- **Atomics:** Use generic types from `sync/atomic` (e.g., `atomic.Pointer[T]`).
- **WaitGroup:** Use `sync.WaitGroup.Go` — replaces `Add(1); go func() { defer Done() }()` (Go 1.25).
- **SIMD:** Use `simd/archsimd` (Go 1.26, experimental, `GOEXPERIMENT=simd`) for vectorized hot paths — `Float32x4`, `Int32x4`, etc. with `Load`/`Store`/`Add`/`Mul`/`MulAdd` ops.
- **Sync Testing:** Use `testing/synctest` for deterministic concurrent tests with virtual clocks (Go 1.25+).
- **Benchmarks:** Use `b.Loop()` (Go 1.24) — automatic timer management, exactly-once-per-count, keeps variables alive. In Go 1.26, no longer blocks inlining of the loop body.
- **Storage/database hot paths:** Pre-allocate slices with `make([]T, 0, capacity)`. Avoid `append` in tight I/O loops without pre-sizing. Size buffers at initialization, not per-operation.
- **Invariant assertions:** Use `panic` (not `log.Fatal`) for invariant violations in non-trivial functions — things that should never happen, not user/input errors. Document the invariant being asserted.
  ```go
  for b.Loop() {
      // implementation
  }
  ```

### 4. Naming

- **Receivers:** 1-2 letter abbreviation of the type — never `self`/`this`. `(c *Client)`, `(srv *Server)`.
- **No type encoding:** `users` not `userSlice`; `count` not `numUsers`. Only qualify when two forms coexist (`age`/`ageStr`).
- **Reader/Writer params:** Always `r io.Reader`, `w io.Writer` — fixed conventions.
- **Exported names:** Package name is part of the call site — `http.Client` not `http.HTTPClient`. No cryptic abbreviations.
- **Units in systems/storage code:** When unit confusion is a real risk (mixed ms/ns, bytes/pages), append units as suffixes — `latencyMs`, `sizeBytes`, `timeoutMsMax`. Don't force this on every variable; Go style prefers terseness where context is clear.

### 5. Error Handling

- **Type-Safe Unwrapping:** Use `errors.AsType[T](err)` (Go 1.26).
  ```go
  if e, ok := errors.AsType[*MyErr](err); ok { ... }
  ```
- **Wrapping:** Always use `fmt.Errorf("...: %w", err)`.

## 🏗️ Tooling & Workspace

- **Modern Fix:** Use `go fix` to migrate to current idioms. Preview with `go fix -diff ./...`.
- **Flight Recorder:** `runtime/trace.FlightRecorder` (Go 1.25) — ring-buffer trace capture for production; call `WriteTo` on significant events.
- **Goroutine Leak Profile:** `GOEXPERIMENT=goroutineleakprofile` → `/debug/pprof/goroutineleak`. No overhead unless queried. Expected default in Go 1.27.
- **Dependencies:** Use `tool` directive in `go.mod` for dev tools (Go 1.24+). Run with `go tool <pkg>`.
- **Workspaces:** Default to `go.work` for multi-module development.
- **Formatting:** `goimports` → `golines --base-formatter gofumpt`.
- **Tidying:** `go mod tidy` after every dependency change.
