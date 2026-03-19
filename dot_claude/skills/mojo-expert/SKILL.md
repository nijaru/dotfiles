---
name: mojo-expert
description: Use when needing idiomatic, high-performance Mojo (v26.1, pre-1.0) guidance for GPU kernels, SIMD-accelerated algorithms, or Python-interop performance libraries.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# Mojo Expert (v26.1 / pre-1.0)

## Core Mandates

- **`fn` over `def`:** Use `fn` for all performance-critical and systems code — enforces strict typing, argument conventions, and compiler optimization. `def` is for Python-compatibility or quick scripting only.
- **Parameterization first:** Prefer compile-time parameters over runtime branching. `@parameter if` for hardware-specific paths. Zero-cost abstractions via specialization.
- **Value semantics by default:** Copies are independent — no aliasing bugs. Use `read`/`mut`/`var` conventions explicitly when sharing or mutating.
- **Traits for abstraction:** Write generic functions against traits, not concrete types. Traits are compile-time dispatched (zero overhead).
- **Linear types:** Generic code should bound on `AnyType`, not `ImplicitlyDestructible`, to support explicitly-destroyed types. Only add `ImplicitlyDestructible` if you truly need implicit drop.

## Prohibited Patterns

- **NO** `borrowed`/`inout`/`owned` keywords — these are legacy. Use `read`/`mut`/`var` (renamed in 25.x).
- **NO** `def` in hot paths or kernel code — no strict typing means missed optimizations.
- **NO** `T: ImplicitlyDestructible` in generic library code unless required — blocks linear type support.
- **NO** `String(unsafe_from_utf8=bytes)` without a `# SAFETY:` comment explaining why UTF-8 is guaranteed.
- **NO** bare Python calls without `raises` — all Python interop can throw; unhandled exceptions are bugs.
- **NO** `@parameter if` without enclosing `fn` — parametric branching requires `fn` not `def`.
- **NO** runtime type dispatch where compile-time parameterization works — vtables are avoidable in Mojo.
- **NO** `UInt` as a struct — it's now a type alias to `Scalar[DType.uint]`; beware implicit conversion breakage.

## Technical Standards

### 1. Argument Conventions

| Keyword | Meaning                             | Old name   |
| ------- | ----------------------------------- | ---------- |
| `read`  | Immutable borrow (no copy)          | `borrowed` |
| `mut`   | Mutable borrow (in-place mutation)  | `inout`    |
| `var`   | Ownership transfer (callee owns it) | `owned`    |

```mojo
fn process(read data: Tensor, mut counter: Int, var buf: Buffer):
    counter += 1          # mutates caller's variable
    buf.resize(...)       # buf is now owned by this function
```

### 2. Struct & Trait Patterns

- **`@value` decorator:** Auto-generates `__init__`, `__copyinit__`, `__moveinit__`. Use for plain data structs.
- **Trait default impls (26.1):** `Hashable`, `Writable`, `Equatable` now derive from struct fields via reflection. No boilerplate for simple structs — just add the conformance.
- **Explicitly-destroyed types (26.1):** Omit `__del__` to make a type linear. The compiler requires the user to call a named destructor. Use to enforce invariants (e.g., must call `.close()`, `.commit()`).

```mojo
struct Connection(Writable):  # Writable impl derived automatically via reflection
    var host: String
    var port: Int

    fn destroy(var self):     # explicit destructor — compiler enforces it's called
        self._close_socket()
```

### 3. Parameterization & Compile-Time Metaprogramming

- `@parameter if condition:` for compile-time hardware/feature branching — generates zero dead code.
- `alias N: Int = 8` inside a function for named compile-time constants.
- Pass types and integers as parameters for specialization: `fn kernel[dtype: DType, width: Int]()`.
- Compile-time reflection (26.1): `reflection.fields_of[T]()`, byte offsets, trait conformance checks.

```mojo
@parameter if is_nvidia_gpu():
    # NVIDIA-specific MMA tile code
else:
    # Generic fallback
```

### 4. SIMD & Vectorization

- `SIMD[DType.float32, 8]` — fixed-width vector type. Operations are element-wise by default.
- `simd_width_of[DType.float32]()` — query optimal SIMD width for current target at compile time.
- `vectorize[simd_width](n, fn[width](i))` — auto-vectorizing loop over `n` elements.
- Use `@parameter` to specialize the inner function for different widths (tail handling).

```mojo
fn square_inplace(ptr: UnsafePointer[Float32], n: Int):
    alias simd_w = simd_width_of[DType.float32]()
    @parameter
    fn kernel[width: Int](i: Int):
        ptr.store[width=width](i, ptr.load[width=width](i) ** 2)
    vectorize[simd_w](n, kernel)
```

### 5. GPU Kernel Writing

- Import `gpu` package — vendor-agnostic (NVIDIA Ampere/Hopper, AMD MI300+).
- Kernel functions must be `fn`, use `@parameter` for compile-time dispatch.
- Launch via `device.enqueue_function[kernel_fn](grid_dim=..., block_dim=...)`.
- `thread_idx()`, `block_idx()`, `block_dim()` for thread coordinates inside kernels.
- Shared memory: `stack_allocation[size, dtype]()` inside kernel.

```mojo
fn matmul_kernel[dtype: DType](
    a: UnsafePointer[Scalar[dtype]],
    b: UnsafePointer[Scalar[dtype]],
    c: UnsafePointer[Scalar[dtype]],
    n: Int,
):
    var row = block_idx().y * block_dim().y + thread_idx().y
    var col = block_idx().x * block_dim().x + thread_idx().x
    # ...

# Launch:
device.enqueue_function[matmul_kernel[DType.float32]](
    a_ptr, b_ptr, c_ptr, n, grid_dim=(n // 16, n // 16), block_dim=(16, 16)
)
```

### 6. Error Handling

- **`raises`** — functions that can fail must declare it. Propagate with `try expr`.
- **Typed errors (26.1):** `fn foo() raises MyError -> Int` — zero-cost (alternate return, no stack unwinding). Preferred for GPU/embedded code where exceptions are expensive.
- **`try`/`except`** for recovery; let errors propagate otherwise.
- Python interop always `raises` — wrap calls in `try` or propagate.

```mojo
fn open_file(path: String) raises IOError -> File:
    ...

fn parse(path: String) raises -> Data:
    var f = try open_file(path)  # propagates IOError as raises
    ...
```

### 7. Python Interop

- `Python.import_module("numpy")` to import Python modules.
- Mojo functions callable from Python since v0.25.6 (`pip install modular`).
- Always annotate with `raises` when touching Python objects — Python can throw at any call.
- Use `PythonObject` for dynamically-typed Python values; convert to Mojo types at boundaries.
- Hot paths: rewrite in `fn` with `SIMD` types, expose to Python via thin `def` wrappers.

```mojo
fn numpy_to_mojo(arr: PythonObject) raises -> List[Float32]:
    var result = List[Float32]()
    for i in range(int(arr.shape[0])):
        result.append(arr[i].to_float64().cast[DType.float32]())
    return result
```

### 8. Memory & String Safety

- **String constructors (26.1):**
  - `String(from_utf8=bytes)` — validates, `raises` on invalid UTF-8.
  - `String(from_utf8_lossy=bytes)` — replaces bad sequences with `\uFFFD`.
  - `String(unsafe_from_utf8=bytes)` — no validation; requires `# SAFETY:` comment.
- ASAP destruction: values are destroyed after last use, not end of scope — don't hold references past last use.
- `UnsafePointer` for manual memory; pair every `alloc` with `free` via `__del__` or explicit destructor.

## Tooling

- **Build/run:** `mojo build main.mojo` · `mojo run script.mojo`
- **Test:** `mojo test` (built-in test runner)
- **Format:** `mojo format` — run before committing
- **Package manager:** `pixi` (recommended) or `magic` (Modular's CLI)
- **Python install:** `pip install modular` — enables Python→Mojo interop
- **REPL:** `mojo` — interactive shell for prototyping
- **Docs:** `mojo doc` — generates documentation from docstrings
