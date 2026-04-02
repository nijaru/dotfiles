---
name: systems-expert
description: Use when designing or implementing performance-critical, safety-critical, or real-time systems requiring Tiger Style, Mechanical Sympathy, or Data-Oriented Design principles.
allowed-tools: Bash, Read, Write, Edit
---

# Systems Expert (Tiger Style / Mechanical Sympathy / DOD)

## Core Mandates

- **Safety First:** Assertions are used to downgrade catastrophic correctness bugs into liveness bugs (crash instead of corrupt). Minimum 2 assertions per function.
- **Static Memory:** Zero dynamic allocation after initialization (`no_std` / custom allocators). No GC-dependent hot paths.
- **Mechanical Sympathy:** Design for the "grain" of the hardware (L1/L2 cache lines, branch prediction, memory barriers).
- **Hard Limits:** Everything (queues, loops, memory) must have a fixed upper bound to prevent tail latency spikes.
- **Zero Dependencies:** Favor in-house implementations of critical paths over opaque third-party crates/packages.

## Technical Standards

### 1. Control Flow & Memory
| Constraint | Rationale | Standard |
| :--- | :--- | :--- |
| **No Recursion** | Stack Safety | Use explicit stacks or iterative approaches. |
| **No Locks** | No Contention | Use Single-Writer Principle or lock-free structures. |
| **SoA > AoS** | Cache Locality | Prefer Struct of Arrays for SIMD-friendliness and cache hit rate. |
| **Zero Copy** | Data Movement | Use `mmap`, `Span`, or reference-passing to avoid redundant `memcpy`. |

### 2. The "Power of Ten" Applied
- **Simple Loops:** All loops must have a fixed, verifiable upper bound.
- **Assertion Density:** Use assertions to verify invariants, pre-conditions, and post-conditions. If an assertion fails, the system must halt immediately.
- **Explicit Returns:** No `goto` (except for cleanup in C), no hidden control flow.
- **Physical Limits:** Keep functions short (<70 lines) to ensure they fit in the "human mental stack."

### 3. Data-Oriented Design (DOD)
- **Data over Logic:** The layout of data in memory is the most important architectural decision.
- **Mechanical Sympathy:** Align data structures to 64-byte cache lines. Use padding to prevent "False Sharing" in concurrent systems.
- **Batching:** Process data in batches to amortize the cost of I/O and context switches.

## Language-Specific Application

### Rust
- Use `no_std` for core engines.
- Prefer `Pin` and `UnsafeCell` for zero-copy structures over high-level abstractions.
- Avoid the "dependency sprawl" of `crates.io`.

### Go
- Use `sync.Pool` to avoid GC pressure.
- Avoid interface boxing in hot paths.
- Use `unsafe` for direct memory access when necessary for performance.

### Mojo
- Leverage `struct` (value types) and `UnsafePointer` for total memory control.
- Use `SIMD` types explicitly for parallel data processing.
- Apply `comptime` assertions to enforce hardware invariants at compile-time.

## Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "It's just one allocation" | Allocations in hot paths cause non-deterministic tail latency. |
| "The compiler will optimize it" | Trust, but verify with benchmarks and assembly inspection. |
| "We need this library" | Dependencies are hidden complexity. If it's on the hot path, you should own it. |
| "Errors are fine" | In high-performance systems, an error you can't recover from is a bug; crash instead. |
