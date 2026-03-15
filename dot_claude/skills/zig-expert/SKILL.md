---
name: zig-expert
description: Expert guidance for writing idiomatic, high-performance Zig (Master/0.16.0). Use when implementing system-level logic, SIMD-accelerated algorithms, or memory-mapped storage engines.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# Zig Expert (v0.16.0)

Expert directives for high-performance systems programming in Zig.

## 🎯 Mandates

- **Explicit Allocators:** **NEVER** use global allocators. Functions/structs MUST accept `std.mem.Allocator`.
- **Error Handling:** Prefer `try` for propagation and `errdefer` for cleanup.
- **Modern Build System:** Use `b.path("src/main.zig")`. The anonymous struct `.{ .path = ... }` is removed.

## 🛠️ Technical Standards (0.16.0)

### 1. Lazy Type Resolution
The compiler now only analyzes what is used. Use this for "struct as namespace" patterns.
```zig
const Engine = struct {
    platform_state: if (is_linux) LinuxState else WindowsState,
};
```

### 2. SIMD Parallelism
- Use `@Vector(N, T)` for hardware-agnostic parallelism.
- Prefer `@reduce(.Add, vector)` for aggregations.

### 3. Naming Conventions
- `camelCase`: Functions and variables.
- `PascalCase`: Types, structs, and modules.

## 🏗️ Idiomatic Patterns
- **Comptime Specialization:** Use `comptime` parameters for zero-cost abstraction.
- **build.zig.zon:** Always include `version` and `paths`.

## 🚫 Prohibited Patterns
- **NO** `@ptrCast` without checking alignment.
- **NO** using `std.debug.print` in production code.
- **NO** ignoring returned errors (use `_ = ...` if intentional).

## 🚫 Anti-Rationalization
| Excuse | Reality |
| :--- | :--- |
| "I'll use a global allocator for now" | Global state is technical debt that breaks library composability. |
| "This isn't performance-critical" | Zig is for performance. Write it correctly the first time. |
