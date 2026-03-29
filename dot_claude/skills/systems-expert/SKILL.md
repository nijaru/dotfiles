---
name: systems-expert
description: Use for high-performance, safety-critical systems engineering. Incorporates Tiger Style, FoundationDB (DST), LMAX Disruptor, Seastar (Shared-Nothing), and Mojo (IPC/Capabilities).
allowed-tools: Bash, Read, Write, Edit
---

# Systems Expert (Tiger Style / DST / DOD / Shared-Nothing)

## 🎯 Core Mandates

- **Safety First:** Assertions are used to "downgrade catastrophic correctness bugs into liveness bugs" (crash instead of corrupt). Minimum 2 assertions per function.
- **Capability-Based Security:** Resources (disk, net, memory) are accessed via "handles" (Capabilities) passed to functions, not global paths or broad permissions (Chromium Mojo style).
- **Deterministic Simulation Testing (DST):** The system must be 100% deterministic. All I/O, time, and randomness must be injectable so the system can run in a single-threaded simulator (FoundationDB style).
- **Static Memory:** Zero dynamic allocation after initialization (`no_std` / custom allocators). No GC-dependent hot paths.
- **Vectorized Execution:** Process data in "vectors" (batches) to maximize SIMD utilization (ClickHouse/DuckDB style).
- **Zero Dependencies:** Favor in-house implementations of critical paths (SQLite style).

## 🛠️ Technical Standards

### 1. Concurrency & Control Flow
| Pattern | Standard | Rationale |
| :--- | :--- | :--- |
| **Shared-Nothing** | Thread-per-core. Each core owns a memory shard. | Eliminates cross-core cache-coherency traffic (Seastar). |
| **Single-Writer** | Only one thread writes to a specific memory region. | Eliminates lock contention and context-switch overhead (LMAX). |
| **Lock-Free** | Use Atomic operations or Ring Buffers. | Prevents thread-priority inversion. |
| **No Recursion** | Use explicit stacks or iterative loops. | Guarantees stack safety and predictable resource usage. |

### 2. Memory & I/O
| Constraint | Standard | Rationale |
| :--- | :--- | :--- |
| **SoA > AoS** | Struct of Arrays layout. | Maximizes cache locality for SIMD/Vectorized ops (DOD). |
| **Zero-Copy** | Use `mmap`, `Span`, or references. | Avoids redundant `memcpy` overhead in the hot path. |
| **Kernel Bypass** | Use `io_uring` or direct hardware access. | Reduces context-switch overhead for high-frequency I/O. |
| **Cache Padding** | Pad structures to 64-byte boundaries. | Prevents "False Sharing" between CPU cores. |

### 3. Reliability & Testing
- **Crash-Only Design:** No "graceful shutdown." The recovery path is the only path. Ensure the system is always ready to crash and recover instantly (Candea/Fox).
- **Fail-Fast:** If an invariant is violated, the system must halt immediately.
- **Deterministic Seed:** The simulator must reproduce any failure given a single 64-bit seed.

## 🏗️ Language-Specific Application

### Rust
- Use `no_std` for core engines.
- Use `glommio` or `monoio` for thread-per-core io_uring execution.
- Inspect assembly with `cargo-show-asm` to verify SIMD vectorization.

### Go
- Use `sync.Pool` to reuse objects.
- Avoid interface boxing in hot paths (`any`).
- Use `unsafe` for direct memory layout control and hardware alignment.

### Mojo
- **Core Architecture:** Design for `struct` (value types) and explicit sharding across cores.
- **Vectorization:** Use `SIMD` types explicitly for vectorized data processing.
- **Compile-Time Safety:** Use `comptime` assertions to enforce hardware-specific invariants and capability constraints.

## 🚫 Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "A little GC is fine" | Non-deterministic pauses are unacceptable in high-performance engines. |
| "We need locks here" | Locks are a design failure. Re-shard the data to avoid contention. |
| "Shutdown is needed" | Graceful shutdown code is rarely tested and often buggy. Rely on crash recovery. |
| "Simulation is too hard" | If you can't simulate it, you can't prove it's correct under concurrency. |
