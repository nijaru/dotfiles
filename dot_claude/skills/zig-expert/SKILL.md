---
name: zig-expert
description: Use when needing idiomatic, high-performance Zig (Master/0.16.0) guidance for system-level logic, SIMD-accelerated algorithms, or memory-mapped storage engines.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# Zig Expert (0.16.0 / Master)

## Core Mandates

- **Explicit Allocators:** Functions and structs MUST accept `std.mem.Allocator`. Never use global allocators.
- **Error Handling:** `try` for propagation, `errdefer` for cleanup. Never ignore errors silently.
- **Comptime First:** Prefer comptime specialization over runtime branching. Zero-cost abstraction.
- **Unmanaged by Default:** Use unmanaged containers (`ArrayListUnmanaged`, `HashMapUnmanaged`) — managed variants deprecated.

## Prohibited Patterns

- **NO** `usingnamespace` — removed in 0.15. Use explicit imports or conditional compilation.
- **NO** `async`/`await` — removed in 0.15. Use `std.Io.Evented` for async I/O (0.16+).
- **NO** `@fence` — removed in 0.14. Use stronger atomic orderings (`SeqCst`, `AcqRel`) instead.
- **NO** `@setCold` — replaced by `@branchHint(.cold)` (0.14).
- **NO** `@ptrCast` without checking alignment — triggers undefined behavior.
- **NO** `std.debug.print` in production code — debug-only.
- **NO** ignoring returned errors — use `_ = expr catch {}` if intentional.
- **NO** `root_source_file` in build.zig — removed in 0.15, use `root_module`.
- **NO** `GeneralPurposeAllocator` by name — renamed to `DebugAllocator` in 0.14.
- **NO** lossy int-to-float implicit coercion — compile error since 0.15; use explicit float literals.
- **NO** `{}` format verb to call format methods — use `{f}` since 0.15.

## Technical Standards

### 1. Language Features

- **Labeled Switch (0.14):** Use for finite state machines — `continue :fsm .next_state` enables CPU branch prediction hints.
  ```zig
  fsm: switch (state) {
      .idle => { state = .running; continue :fsm state; },
      .running => { ... },
  }
  ```
- **Decl Literals (0.14):** `.init` and `.default` reference struct declarations, not just enum variants. Prefer `.init` over `MyStruct{}` for explicit initialization.
- **`@branchHint` (0.14):** Replaces `@setCold`. Use `.likely`, `.unlikely`, `.cold`, `.unpredictable`.
- **`@FieldType(T, "field")` (0.14):** Compile-time field type introspection without `@TypeOf`.
- **`@ptrCast` Extensions (0.14/0.15):** Can change slice lengths; can convert `*T` to slices.
- **Lazy Type Resolution (0.16):** Compiler only analyzes fields when the type is instantiated — struct-as-namespace pattern now fully zero-cost.
- **Naming:** `camelCase` for functions/variables · `PascalCase` for types/structs/modules.

### 2. Memory & Allocators

- **`DebugAllocator`** (formerly `GeneralPurposeAllocator`, renamed 0.14): Debug/test builds only.
- **`SmpAllocator`** (0.14): Use for multithreaded `ReleaseFast` builds — lock-free, NUMA-aware.
- **`remap`** (0.14): New allocator method for resize-with-possible-relocation. Prefer over manual free+alloc.
- **Unmanaged containers** (default since 0.15): `ArrayListUnmanaged`, `HashMapUnmanaged` — pass allocator at each call site.
- **Intrusive linked lists:** Use `@fieldParentPtr` — linked lists de-genericified in 0.15, store node in struct, recover parent via pointer arithmetic.

### 3. SIMD & Performance

- Use `@Vector(N, T)` for hardware-agnostic SIMD parallelism.
- `@reduce(.Add, vec)` for aggregations · `@splat(scalar)` for broadcasting (also works on arrays, 0.14).
- Use `comptime` parameters for zero-cost specialization — avoids vtable dispatch.
- `@branchHint(.unlikely)` on error paths; `@branchHint(.cold)` on panic/abort paths.

### 4. I/O (0.15+)

- **`std.Io.Reader` / `std.Io.Writer`:** Non-generic, buffered interfaces replacing old generic reader/writer. Buffer is embedded in the interface.
- **`std.Io.Evented` (0.16):** Async I/O via io_uring (Linux) or Grand Central Dispatch (macOS) using stackful coroutines. Backends are swappable with identical application code.
- **Format specifiers:** `{f}` calls format method · `{t}` for `@tagName`/`@errorName` · `{b64}` for base64 · `{d}` for custom number formatting.

### 5. Error Handling & Safety

- Chain `errdefer` for all cleanup before `try` calls that may fail.
- Only `undefined` operands with operators that cannot trigger UB (enforced by compiler since 0.15).
- ZON (Zig Object Notation) for data serialization at comptime and runtime (0.14).
- **Invariant assertions:** Use `std.debug.assert` for preconditions and postconditions on non-trivial functions. Positive statements (`assert(x > 0)`) over negations (`assert(!(x <= 0))`).

## Build System (0.15+)

- **`root_module` field** (required since 0.15): Replaces `root_source_file` in `addExecutable`/`addLibrary`.
- **`--watch`** for continuous rebuilds · **`--webui`** for live build dashboard · **`--time-report`** for profiling.
- **`zig-pkg/`** (0.16): Fetched packages stored locally alongside `build.zig` for reproducible offline builds.
- **`build.zig.zon`**: Always include `version` and `paths` fields.

## Tooling

- **Fast debug builds:** x86_64 backend default in debug mode since 0.15 (~5x faster than LLVM). Use `-fllvm` to opt out.
- **Incremental compilation:** `-fincremental --watch` for 63ms rebuilds on large codebases.
- **Threaded codegen (0.15):** Sema, codegen, and linking run in parallel — up to 50% wall-clock reduction.
