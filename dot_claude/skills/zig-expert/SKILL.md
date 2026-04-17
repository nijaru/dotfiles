---
name: zig-expert
description: Use when needing idiomatic, high-performance Zig guidance across recent stable versions (0.14-0.16), especially for systems code, allocator design, build.zig migration, or stdlib/runtime API changes.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# Zig Expert (0.14-0.16)

## Core Mandates

- **Target-aware:** Default to the newest stable Zig semantics unless the repo pins an older compiler. When version drift matters, say which rule is `0.14`, `0.15`, or `0.16`.
- **Explicit allocation:** Pass `std.mem.Allocator` at API boundaries that allocate. Hide ownership in types, not globals.
- **Error-first:** Use `try`, `catch`, and `errdefer` deliberately. Do not erase error sets just to make types easier.
- **Comptime over indirection:** Prefer comptime parameters, tagged unions, and small structs over trait-object-style abstraction.
- **Zig, not cargo cult:** Prefer Zig stdlib patterns over importing Rust, Go, or C++ architecture by analogy.

## Prohibited Patterns

- **NO** `usingnamespace` in new code. It was removed in `0.15`.
- **NO** language-level `async` / `await`. They were removed in `0.15`.
- **NO** `@fence` or `@setCold`. Use atomics plus `@branchHint`.
- **NO** `@Type` in `0.16+`. Use `@Struct`, `@Union`, `@Enum`, `@Opaque`, `@Array`, `@Vector`, and related builtins.
- **NO** `root_source_file` on `addExecutable` / `addLibrary`. Use `.root_module`.
- **NO** stale reader/writer APIs (`GenericReader`, `AnyReader`, old buffered wrappers) in `0.15+`.
- **NO** `std.Thread.Pool` in `0.16+`. It was removed; use `std.Io`.
- **NO** managed-container bias in new code. Prefer unmanaged containers when lifetime control matters.
- **NO** `std.debug.print` in production paths.

## Technical Standards

### 1. Language & Data Layout

- Use **labeled `switch`** (`0.14`) for finite-state dispatch and hot control flow.
- Use **decl literals** (`.init`, `.default`) instead of repeating the type at the call site.
- Use `@FieldType`, `@fieldParentPtr`, `@Vector`, `@reduce`, and `@splat` where they simplify real systems code.
- Prefer enums, tagged unions, and explicit backing types over integer protocols and stringly typed state.
- Use `camelCase` for values/functions and `PascalCase` for types/modules.

### 2. Memory & Containers

- Use `std.heap.DebugAllocator` for tests and debug diagnostics.
- Use `std.heap.smp_allocator` for multithreaded general-purpose release allocation when appropriate.
- Use `ArenaAllocator` only for clearly bounded lifetimes; free the arena at one obvious boundary.
- Prefer allocator `remap` over hand-rolled realloc patterns.
- Prefer `ArrayListUnmanaged` / `HashMapUnmanaged` in infrastructure code where allocator flow should stay explicit.

### 3. I/O, Concurrency, and Runtime

- `0.15` introduced the non-generic `std.Io.Reader` / `std.Io.Writer` direction; `0.16` turns I/O into a real interface.
- In `0.16`, use `std.Io` as the concurrency model: `Future`, `Group`, cancelation, `Threaded`, and `Evented`.
- Treat Zig concurrency as **library-level**, not language-level. There are no goroutines, channels, or `async fn` equivalents.
- Prefer `std.testing.io` and real stdlib primitives over fake adapters in tests.

### 4. Build System & Toolchain

- On `0.15+`, construct artifacts around `.root_module`; use `b.createModule` when you need a module with its own `root_source_file`.
- Keep `build.zig.zon` present and explicit. Include `version` and `paths`.
- Expect `zig-pkg/` next to `build.zig` in `0.16`; do not assume all fetched packages live only in the global cache.
- Use `zig build --watch`, `--webui`, and `--time-report` when iterating on compiler or build latency issues.

## Recent-Version Map

- **`0.14`**: labeled `switch`, decl literals, `@branchHint`, `@FieldType`, `DebugAllocator`, `smp_allocator`, allocator `remap`, stronger unmanaged-container direction.
- **`0.15`**: `usingnamespace` removed, `async` / `await` removed, lossy int-to-float coercions rejected, `{f}` required for format methods, `root_module` required on artifact creation, Writergate I/O APIs landed.
- **`0.16`**: `@Type` removed, lazy field analysis, `std.Io` interface with futures/groups/cancelation, `Thread.Pool` removed, `zig-pkg/` moved into the project.

## Workflow

- First identify the Zig version actually pinned by the repo.
- Then write to that version directly; do not generate master-branch syntax for a `0.14` or `0.15` project.
- When modernizing code, replace obsolete APIs outright instead of layering compatibility shims unless the user explicitly asks for dual-version support.
