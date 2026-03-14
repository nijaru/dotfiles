---
name: zig-expert
description: Expert guidance for writing idiomatic, high-performance Zig (Master/0.16.0). Use when implementing system-level logic, SIMD-accelerated algorithms, or memory-mapped storage engines.
---

# Zig Expert Guide (v0.16.0-dev)

## 🛠️ Core Directives

- **Explicit Allocators:** **NEVER** use global allocators. Functions/structs that allocate **MUST** accept `std.mem.Allocator`.
- **Error Handling:** Prefer `try` for propagation and `errdefer` for cleanup.
- **Lazier Type Resolution (New in 0.16.0):** The compiler now only analyzes what you use. You can define "invalid" or "erroring" fields in a struct, and as long as they aren't initialized or accessed, the compiler won't complain. Use this for "struct as namespace" patterns.
- **SIMD with @Vector:** Use `@Vector(N, T)`. Prefer it for hardware-agnostic parallelism.
- **Naming:** `camelCase` for functions/variables, `PascalCase` for types/structs.

---

## 🏗️ Build System (0.16.0)

### 1. Source Paths
Always use `b.path("src/main.zig")`. The anonymous struct `.{ .path = "..." }` is deprecated/removed.

### 2. build.zig.zon
Ensure your `.zon` file includes your `version` and `paths`.

---

## 🏗️ Idiomatic Patterns

### 1. Lazy Type Pattern (0.16.0+)
```zig
const Engine = struct {
    // This field might be invalid for some platforms, 
    // but the compiler won't care unless we use it.
    platform_specific: if (is_linux) LinuxState else WindowsState,

    pub fn init() Engine { ... }
};
```

### 2. Comptime Specialization
```zig
fn dotProduct(comptime dim: usize, a: [dim]f32, b: [dim]f32) f32 {
    const V = @Vector(dim, f32);
    const va: V = a;
    const vb: V = b;
    return @reduce(.Add, va * vb);
}
```

---

## 📂 Reference Material

- **SIMD Deep Dive:** See [references/simd.md](references/simd.md) for `@Vector` and `@reduce` patterns.
- **Memory & Pointers:** See [references/memory.md](references/memory.md) for slices and alignment.
- **Master Changes:** See [references/master.md](references/master.md) for Type Resolution PR specifics.
