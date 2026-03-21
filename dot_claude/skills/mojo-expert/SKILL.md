---
name: mojo-expert
description: Use when needing idiomatic, high-performance Mojo (v26.2, pre-1.0) guidance for GPU kernels, SIMD-accelerated algorithms, or Python-interop performance libraries.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# Mojo Expert (v26.2 / pre-1.0)

## Core Mandates

- **`def` over `fn`:** `fn` is deprecated as of v26.2. Use `def` with explicit `raises` for error handling. `def` now has non-raising semantics by default.
- **Parameterization first:** Prefer compile-time parameters over runtime branching. `comptime if` for hardware-specific paths. Zero-cost abstractions via specialization.
- **Value semantics by default:** Copies are independent — no aliasing bugs. Use `read`/`mut`/`var` conventions explicitly when sharing or mutating.
- **Traits for abstraction:** Write generic functions against traits, not concrete types. Traits are compile-time dispatched (zero overhead).
- **Conditional trait conformances:** Use `where` clauses to constrain trait conformances on type parameters.
- **Linear types:** Generic code should bound on `AnyType`, not `ImplicitlyDestructible`, to support explicitly-destroyed types.

## Prohibited Patterns

- **NO** `fn` keyword — deprecated in v26.2. Use `def`.
- **NO** `borrowed`/`inout`/`owned` keywords — legacy/removed. Use `read`/`mut`/`var`.
- **NO** `@parameter if` / `@parameter for` — replaced by `comptime if` / `comptime for`.
- **NO** `__moveinit__`/`__copyinit__` — renamed to `__init__(take=...)` / `__init__(copy=...)`.
- **NO** `T: ImplicitlyDestructible` in generic library code unless required — blocks linear type support.
- **NO** `String(unsafe_from_utf8=bytes)` without a `# SAFETY:` comment explaining why UTF-8 is guaranteed.
- **NO** bare Python calls without `raises` — all Python interop can throw.
- **NO** runtime type dispatch where compile-time parameterization works — vtables are avoidable in Mojo.
- **NO** `UInt` as a struct — it's a type alias to `Scalar[DType.uint]`.
- **NO** `@register_passable` — deprecated, use trait conformance instead.
- **NO** `Stringable`/`Representable` traits — use `Writable` instead.
- **NO** `.🔥` or `📦` file extensions — removed.

## Technical Standards

### 1. Argument Conventions

| Keyword | Meaning                             | Old name   |
| ------- | ----------------------------------- | ---------- |
| `read`  | Immutable borrow (no copy)          | `borrowed` |
| `mut`   | Mutable borrow (in-place mutation)  | `inout`    |
| `var`   | Ownership transfer (callee owns it) | `owned`    |

```mojo
def process(read data: Tensor, mut counter: Int, var buf: Buffer):
    counter += 1
    buf.resize(...)
```

### 2. Struct & Trait Patterns

- **`@value` decorator:** Auto-generates `__init__`, copy, and move. Use for plain data structs.
- **Trait default impls:** `Hashable`, `Writable`, `Equatable` derive from struct fields via reflection.
- **Conditional conformances:** Use `where` clauses for type-parameter-gated trait conformances.
- **Init unification:** `__moveinit__` → `__init__(take: Self)`, `__copyinit__` → `__init__(copy: Self)`.
- **Explicitly-destroyed types:** Omit `__del__` to make a type linear; provide a named destructor instead.
- **`@align(N)`:** Specifies minimum struct alignment in bytes.

```mojo
struct Connection(Writable):  # impl derived via reflection
    var host: String
    var port: Int

    def destroy(var self):    # explicit destructor — compiler enforces it's called
        self._close_socket()
```

### 3. Compile-Time Metaprogramming

- `comptime if condition:` — replaces `@parameter if`. Zero dead code.
- `comptime for i in range(N):` — replaces `@parameter for`.
- `alias N: Int = 8` inside a function for named compile-time constants.
- Pass types and integers as parameters: `def kernel[dtype: DType, width: Int]()`.
- Compile-time reflection: `reflection.fields_of[T]()`, byte offsets, trait conformance checks.

```mojo
comptime if is_nvidia_gpu():
    # NVIDIA-specific MMA tile code
else:
    # Generic fallback
```

### 4. Template Strings (T-strings)

New `t"..."` syntax captures format strings and runtime args as `TString` without immediate allocation. Use `rt"..."` for raw (literal backslashes).

```mojo
def log(name: String, value: Int):
    var msg = t"name={name} value={value}"  # no allocation yet
    print(msg)
```

### 5. SIMD & Vectorization

- `SIMD[DType.float32, 8]` — fixed-width vector. Operations are element-wise.
- `simd_width_of[DType.float32]()` — optimal SIMD width for current target at compile time.
- `vectorize[simd_width](n, fn[width](i))` — auto-vectorizing loop.
- `Bool` no longer conforms to `Indexer` — use explicit int conversion.

```mojo
def square_inplace(ptr: UnsafePointer[Float32], n: Int):
    alias simd_w = simd_width_of[DType.float32]()
    @parameter
    def kernel[width: Int](i: Int):
        ptr.store[width=width](i, ptr.load[width=width](i) ** 2)
    vectorize[simd_w](n, kernel)
```

### 6. GPU Kernel Writing

- Import `gpu` package — vendor-agnostic (NVIDIA Ampere/Hopper, AMD MI300+).
- Kernel functions use `@parameter` for compile-time dispatch.
- Launch via `device.enqueue_function[kernel_fn](grid_dim=..., block_dim=...)`.
- `thread_idx()`, `block_idx()`, `block_dim()` for thread coordinates.
- Shared memory: `stack_allocation[size, dtype]()` inside kernel.

```mojo
def matmul_kernel[dtype: DType](
    a: UnsafePointer[Scalar[dtype]],
    b: UnsafePointer[Scalar[dtype]],
    c: UnsafePointer[Scalar[dtype]],
    n: Int,
):
    var row = block_idx().y * block_dim().y + thread_idx().y
    var col = block_idx().x * block_dim().x + thread_idx().x
    # ...

device.enqueue_function[matmul_kernel[DType.float32]](
    a_ptr, b_ptr, c_ptr, n, grid_dim=(n // 16, n // 16), block_dim=(16, 16)
)
```

### 7. Error Handling

- **`raises`** — functions that can fail must declare it. `def foo() raises -> Int`.
- **`assert`** — desugars to `debug_assert()`, respects `-D ASSERT` flag.
- **`try`/`except`** for recovery; let errors propagate otherwise.
- Python interop always `raises` — wrap calls in `try` or propagate.

```mojo
def open_file(path: String) raises IOError -> File:
    ...

def parse(path: String) raises -> Data:
    var f = try open_file(path)
    ...
```

### 8. Standard Library Highlights

- **`Dict`:** Now uses Swiss Table (SIMD group probing), load factor 7/8 — faster than before.
- **itertools:** `cycle()`, `take_while[predicate]()`, `drop_while[predicate]()` added.
- **String safety:** Subscripting panics on mid-codepoint indices. `String.resize()` panics on invalid UTF-8.
- **`@doc_hidden`:** Replaces `@doc_private`.

### 9. Python Interop

- `Python.import_module("numpy")` to import Python modules.
- Mojo callable from Python via `pip install modular`.
- Always annotate with `raises` when touching Python objects.
- Use `PythonObject` for dynamically-typed values; convert to Mojo types at boundaries.

```mojo
def numpy_to_mojo(arr: PythonObject) raises -> List[Float32]:
    var result = List[Float32]()
    for i in range(int(arr.shape[0])):
        result.append(arr[i].to_float64().cast[DType.float32]())
    return result
```

### 10. Memory Safety

- **String constructors:**
  - `String(from_utf8=bytes)` — validates, `raises` on invalid UTF-8.
  - `String(from_utf8_lossy=bytes)` — replaces bad sequences with `\uFFFD`.
  - `String(unsafe_from_utf8=bytes)` — no validation; requires `# SAFETY:` comment.
- ASAP destruction: values destroyed after last use, not end of scope.
- `UnsafePointer` for manual memory; pair every `alloc` with `free`.

## Tooling

- **Build/run:** `mojo build main.mojo` · `mojo run script.mojo`
- **Test:** `mojo test`
- **Format:** `mojo format` — run before committing
- **Package manager:** `pixi` (recommended) or `magic`
- **Python install:** `pip install modular`
- **REPL:** `mojo`
- **Docs:** `mojo doc`
