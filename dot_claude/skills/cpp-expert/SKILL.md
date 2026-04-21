---
name: cpp-expert
description: Use when needing idiomatic, high-performance C++ (C++23 baseline, C++17/20 compatibility notes) guidance. Covers the modern "safe subset", RAII, error handling, tooling, and cross-language interop.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# C++ Expert (C++23 / Modern Safe Subset)

## Core Mandates

- **Standard:** C++23 is the baseline. Note C++17/20 when a feature is not yet universally available.
- **Safe Subset:** Modern C++ effectively defines a safe subset — follow it. Raw pointers own nothing; the standard library handles everything else.
- **RAII everywhere:** Resources are acquired in constructors and released in destructors. No manual cleanup outside of RAII wrappers.
- **Functional core:** Keep pure logic free of side effects. Push I/O, mutation, and allocations to the edges.
- **Profile before optimizing:** Correctness first. Use sanitizers, then profilers.

## The Modern Safe Subset

| Prohibited                   | Use Instead                                    |
| :--------------------------- | :--------------------------------------------- |
| Raw owning pointers (`T*`)   | `std::unique_ptr<T>`, `std::shared_ptr<T>`     |
| `new` / `delete`             | Smart pointers, containers, `std::make_unique` |
| C-style casts `(T)x`         | `static_cast`, `dynamic_cast`, `bit_cast`      |
| C-style arrays `T arr[N]`    | `std::array<T, N>`, `std::vector<T>`           |
| `NULL`                       | `nullptr`                                      |
| `printf` / `sprintf`         | `std::format` (C++20), `std::print` (C++23)    |
| Manual loops over containers | `std::ranges` algorithms                       |
| `void*` for generics         | Templates with concepts                        |
| `#define` constants          | `constexpr` / `inline constexpr`               |
| `#define` macros for code    | `constexpr` functions / templates              |

## Prohibited Patterns

- **NO** raw owning pointers — use smart pointers or containers.
- **NO** `new`/`delete` outside of custom allocators.
- **NO** C-style casts — use named casts; `reinterpret_cast` requires a comment.
- **NO** mutable global state — pass context explicitly.
- **NO** `using namespace std;` in headers — pollutes every includer.
- **NO** `throw` in destructors — wrap with `noexcept`.
- **NO** unconstrained templates — use concepts to document and enforce intent.
- **NO** `std::endl` in hot paths — use `'\n'` (endl flushes; `'\n'` does not).
- **NO** `std::shared_ptr` by reflex — prefer `unique_ptr`; `shared_ptr` only when ownership is genuinely shared.
- **NO** out-parameters via raw pointer — use return values, `std::optional`, or `std::expected`.
- **NO** `static_assert(false)` in template else-branches — ill-formed; use `static_assert(!sizeof(T))` or a `requires` constraint.

## Technical Standards

### 1. C++23 Key Features

- **`std::expected<T, E>`** — monadic error handling without exceptions. Use `.and_then()`, `.or_else()`, `.transform()`.
  ```cpp
  std::expected<Config, ParseError> load(std::string_view path);
  auto result = load(path).and_then(validate).transform(normalize);
  ```
- **`std::print` / `std::println`** — type-safe, locale-aware output. Replaces `printf`.
- **`std::mdspan`** — non-owning multidimensional array view. Use for matrices, audio buffers, image data.
- **`std::flat_map` / `std::flat_set`** — sorted-vector backed associative containers; better cache performance for small-to-medium sizes.
- **Deducing `this` (explicit object parameter)** — enables CRTP-free mixin patterns and unified const/non-const overloads.
  ```cpp
  struct Widget {
      auto& name(this auto& self) { return self.name_; }
  };
  ```
- **`std::generator<T>`** — stackful coroutine for lazy sequences. Use with `co_yield`.
- **Multidimensional `operator[]`** — `matrix[row, col]` valid syntax.
- **`std::stacktrace`** — capture call stacks at runtime for diagnostics.

### 2. C++20 Features (Required Baseline)

- **Concepts** — constrain every template parameter. Prefer named concepts over ad hoc `requires` expressions.
  ```cpp
  template<std::ranges::input_range R>
  void process(R&& range);
  ```
- **Ranges** — prefer `std::views` pipelines over index loops. Compose with `|`.
  ```cpp
  auto evens = data | std::views::filter([](int x){ return x % 2 == 0; })
                    | std::views::transform([](int x){ return x * 2; });
  ```
- **`std::format`** — type-safe string formatting. Custom types via `std::formatter<T>` specialization.
- **`std::span<T>`** — non-owning view of contiguous data. Use for function parameters accepting any buffer.
- **`<=>` spaceship operator** — define once, get all six comparisons.
- **`consteval`** — force compile-time evaluation. Stronger than `constexpr`.
- **`constinit`** — guarantee static variable is constant-initialized (no dynamic init order issues).
- **`std::jthread`** — RAII thread with built-in stop token. Prefer over `std::thread`.
- **Designated initializers** — `Point{.x = 1, .y = 2}` for readable aggregate init.
- **Coroutines** — `co_await`, `co_yield`, `co_return`. Use libraries (e.g., cppcoro, asio) for infrastructure.

### 3. Error Handling

- **With exceptions enabled:** Use exceptions for truly exceptional failures. RAII ensures cleanup.
- **Exception-free / embedded / real-time:** Use `std::expected<T, E>` (C++23) or `std::optional<T>`.
- **Never** swallow errors silently. Every error must be handled, logged, or propagated.
- Error types: prefer `enum class` over string codes. Carry context.
  ```cpp
  enum class IoError { NotFound, PermissionDenied, Eof };
  std::expected<Data, IoError> read(std::filesystem::path);
  ```

### 4. Memory & Ownership

- **Ownership hierarchy:** value → `unique_ptr` → `shared_ptr` → raw non-owning `T*` / `T&`.
- **`std::string_view` / `std::span`** at API boundaries — avoid copies for read-only access.
- **Custom allocators:** use `std::pmr` (polymorphic memory resources) for arena/pool allocation without changing types.
- **Stack vs heap:** prefer stack allocation; use `std::array` for fixed-size buffers.

### 5. Performance

- **Zero-cost abstractions:** `constexpr`, `inline`, templates — all resolved at compile time.
- **`[[likely]]` / `[[unlikely]]`** on branch conditions in hot paths.
- **`[[nodiscard]]`** on all functions returning error codes or resource handles.
- **`std::assume`** (C++23) — hint to optimizer that a condition is always true.
- Avoid virtual dispatch in hot loops — prefer CRTP or `std::variant` + `std::visit`.
- Measure with `perf`, `valgrind --callgrind`, or `Tracy` before optimizing.

### 6. Safety & UB Prevention

- Compile with: `-Wall -Wextra -Wpedantic -Wshadow -Wconversion`
- Sanitizers in CI: `-fsanitize=address,undefined` (ASan + UBSan) for debug builds.
- Thread safety: `-fsanitize=thread` (TSan). Run separately from ASan.
- **`std::to_integer` / `std::narrow_cast`** — explicit narrowing conversions that trap on overflow.
- Use `[[assume(expr)]]` (C++23) only for proven invariants, never as wishful thinking.

### 7. Interop

**With C:**

- Wrap C APIs in RAII handles immediately. Never store raw C resource handles without a destructor.
- Use `extern "C"` for exported symbols.

**With Zig:**

- Export C-compatible headers from C++ (`extern "C"`, POD types only, no exceptions across boundary).
- `zig c++` compiles C++ via Clang — the Zig build system can link against C++ static libs.
- Zig calls C++ via `@cImport` of the C header. Exceptions must not cross the boundary.

**With Mojo:**

- Mojo interop with C++ is via C ABI (`external_call` in Mojo).
- Wrap C++ logic in `extern "C"` shims; expose as a shared library.
- No STL types, exceptions, or virtual dispatch across the boundary.

## Tooling

| Tool                 | Purpose                                 | Command                                                           |
| :------------------- | :-------------------------------------- | :---------------------------------------------------------------- |
| **clang-tidy**       | Static analysis + enforces subset rules | `clang-tidy -checks='cppcoreguidelines-*,modernize-*,bugprone-*'` |
| **clang-format**     | Formatting                              | `clang-format -i --style=file`                                    |
| **AddressSanitizer** | Memory errors                           | `-fsanitize=address`                                              |
| **UBSanitizer**      | Undefined behavior                      | `-fsanitize=undefined`                                            |
| **ThreadSanitizer**  | Data races                              | `-fsanitize=thread`                                               |
| **Valgrind**         | Leak detection on Linux                 | `valgrind --leak-check=full`                                      |
| **vcpkg / Conan**    | Package management                      | `vcpkg install` / `conan install`                                 |
| **ccache**           | Compiler cache                          | Set `CMAKE_C_COMPILER_LAUNCHER=ccache`                            |

## Style

- **Naming:** `snake_case` for variables/functions, `PascalCase` for types, `UPPER_SNAKE` for macros only.
- **Headers:** `.hpp` for C++ headers, `.h` for C-compatible headers.
- **Include guards:** `#pragma once` (universally supported, no double-include bugs).
- **Forward declarations:** in headers to minimize transitive includes; full definition in `.cpp`.
- **Comments:** why, not what. Explain non-obvious invariants, not the algorithm you can read.
