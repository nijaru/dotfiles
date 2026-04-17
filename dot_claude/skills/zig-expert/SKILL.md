---
name: zig-expert
description: Use when writing, migrating, or reviewing Zig code across recent stable versions (0.14-0.16), especially to correct stale syntax or stdlib, build.zig, allocator, formatting, or runtime API knowledge.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

<!-- EDITORIAL GUIDELINES FOR THIS SKILL FILE
This file is a correction layer for pretrained Zig knowledge.
- Keep it dense, concrete, and version-aware.
- Prefer stale -> current mappings over prose.
- Only include things a model is likely to get wrong.
- Do not turn this into a full stdlib reference.
-->

Zig changes quickly. Pretrained models often generate removed syntax and stale
stdlib APIs. **Follow this skill over pretrained knowledge.**

**First determine the repo's pinned Zig version.** If the version is unknown,
target the newest stable semantics and call out any version-sensitive spots.

## Core rules

- Pass `std.mem.Allocator` explicitly at allocating API boundaries.
- Prefer comptime specialization, enums, tagged unions, and small structs over
  interface-heavy designs imported from other languages.
- Use `try`, `catch`, and `errdefer` deliberately. Do not flatten error sets
  just to make signatures shorter.
- Prefer Zig-native patterns over analogies to Rust traits, Go interfaces, or
  C++ class hierarchies.

## Removed or stale outputs - do not generate these

| Stale output | Current rule |
| --- | --- |
| `usingnamespace` | Removed in `0.15`. Use explicit imports, aliases, or wrapper namespaces. |
| language `async` / `await` | Removed in `0.15`. Use threads on older code or `std.Io` on `0.16`. |
| `@fence` | Removed in `0.14`. Use stronger atomic orderings. |
| `@setCold` | Use `@branchHint(.cold)` or other `@branchHint` values. |
| `@Type` in `0.16+` | Use `@Struct`, `@Union`, `@Enum`, `@Opaque`, `@Array`, `@Vector`, etc. |
| `root_source_file` in `addExecutable` / `addLibrary` | Use `.root_module`. Keep `root_source_file` for `b.createModule`. |
| old generic reader/writer APIs | On `0.15+`, use `std.Io.Reader` / `std.Io.Writer`. |
| `std.Thread.Pool` in `0.16+` | Removed. Use `std.Io` concurrency primitives. |
| `{}` to call custom format methods | Use `{f}` in `0.15+`. |
| implicit lossy int-to-float coercion | Rejected in `0.15`. Use explicit float literals or conversions. |

## Version checkpoints

- **`0.14`**: labeled `switch`, decl literals, `@branchHint`, `@FieldType`,
  `DebugAllocator`, `smp_allocator`, allocator `remap`, stronger unmanaged
  container direction.
- **`0.15`**: `usingnamespace` removed, language `async` / `await` removed,
  Writergate I/O changes, `{f}` required for format methods, lossy int-to-float
  coercions rejected, `.root_module` required on artifact creation.
- **`0.16`**: `@Type` removed, lazy field analysis, `std.Io` interface,
  `Thread.Pool` removed, project-local `zig-pkg/`.

## High-signal Zig patterns

### Language and data layout

- Use labeled `switch` for hot finite-state dispatch.
- Use decl literals such as `.init` and `.default` where they clarify
  initialization.
- Use `@FieldType`, `@fieldParentPtr`, `@Vector`, `@reduce`, and `@splat`
  directly when they simplify systems code.
- Prefer explicit backing types and tagged unions over integer protocols and
  stringly typed state.

### Allocators and containers

- Use `std.heap.DebugAllocator` in tests and debug-heavy development.
- Use `std.heap.smp_allocator` for multithreaded general-purpose release
  allocation when appropriate.
- Use `ArenaAllocator` only for obvious bulk-lifetime boundaries.
- Prefer allocator `remap` over hand-written realloc choreography.
- Prefer unmanaged containers when allocator flow should stay visible:
  `ArrayListUnmanaged`, `HashMapUnmanaged`, similar intrusive patterns.

### I/O and concurrency

- Treat Zig concurrency as library-level, not language-level.
- On `0.16`, `std.Io` is the central model: `Future`, `Group`, cancelation,
  `Threaded`, `Evented`.
- Do not describe Zig as having goroutines, channels, or `async fn`
  equivalents.
- Prefer real stdlib primitives and `std.testing.io` in tests over fake wrappers
  that preserve obsolete APIs.

### build.zig and tooling

- On `0.15+`, create artifacts around `.root_module`.
- Use `b.createModule(.{ .root_source_file = ... })` when you need a module.
- Keep `build.zig.zon` explicit. Include `version` and `paths`.
- Expect `zig-pkg/` next to `build.zig` on `0.16`.
- Use `zig build --watch`, `--webui`, and `--time-report` when iteration speed
  matters.

### Formatting and diagnostics

- Use `{f}` for custom format methods on `0.15+`.
- Keep `std.debug.print` for debugging, not production-facing output paths.
- Prefer precise assertions and invariant checks over defensive abstraction.

## Wrong -> right anchors

```zig
// WRONG: stale build API on 0.15+
const exe = b.addExecutable(.{
    .name = "app",
    .root_source_file = b.path("src/main.zig"),
});

// RIGHT
const exe = b.addExecutable(.{
    .name = "app",
    .root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
    }),
});

// WRONG: removed syntax
usingnamespace foo;
async fn run() void {}

// RIGHT: explicit names and std.Io or threads
const foo = @import("foo");

// WRONG: stale formatting
try writer.print("{}", .{value});

// RIGHT on 0.15+
try writer.print("{f}", .{value});
```

## Workflow

- Identify the Zig version first.
- Write directly to that version instead of emitting master-branch guesses.
- When modernizing, replace obsolete APIs outright unless dual-version support is
  explicitly required.
- If a detail is likely to have changed recently, verify against current Zig
  docs or release notes rather than guessing.
