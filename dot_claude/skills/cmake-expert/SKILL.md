---
name: cmake-expert
description: Use when writing, debugging, or structuring CMake build systems for C++, JUCE, or mixed-language projects. Covers modern target-based CMake, presets, FetchContent, and Ninja backend.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# CMake Expert (3.28+)

## Core Mandates

- **Modern CMake:** Everything is a target. Properties flow via `target_*` commands. Global `include_directories`, `link_libraries`, `add_definitions` are banned.
- **Ninja backend:** Always use Ninja for local builds — faster than Makefiles, parallel by default.
- **Presets:** `CMakePresets.json` in the repo root. `CMakeUserPresets.json` in `.gitignore` for local overrides.
- **Out-of-source builds:** Never build in the source tree. Build dir is always separate (managed via presets).
- **`cmake_minimum_required(VERSION 3.28)`** — minimum for C++23 support and current best practices.

## Prohibited Patterns

- **NO** `include_directories()` — use `target_include_directories()`.
- **NO** `link_libraries()` — use `target_link_libraries()`.
- **NO** `add_definitions()` — use `target_compile_definitions()`.
- **NO** `add_compile_options()` globally — use per-target.
- **NO** `file(GLOB ...)` for source files — list explicitly or use `target_sources()`.
- **NO** `cmake_minimum_required` version below 3.22 for new projects.
- **NO** manually setting `CMAKE_CXX_FLAGS` — use `target_compile_options()`.
- **NO** `set(CMAKE_BUILD_TYPE ...)` in `CMakeLists.txt` — set via preset or `-DCMAKE_BUILD_TYPE=`.

## Project Structure

```
project/
├── CMakeLists.txt          # Root: project(), subdirs, find_package
├── CMakePresets.json       # Versioned presets
├── CMakeUserPresets.json   # Local overrides (gitignored)
├── cmake/
│   ├── CompilerWarnings.cmake
│   └── Dependencies.cmake
├── src/
│   └── CMakeLists.txt
├── tests/
│   └── CMakeLists.txt
└── extern/                 # Vendored deps (or use FetchContent)
```

## Canonical Root CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.28)
project(MyProject VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)          # No GNU extensions
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)  # For clang-tidy, clangd

include(cmake/Dependencies.cmake)

add_subdirectory(src)

option(BUILD_TESTS "Build tests" ON)
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
```

## Presets (CMakePresets.json)

```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "base",
      "hidden": true,
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build/${presetName}",
      "cacheVariables": {
        "CMAKE_EXPORT_COMPILE_COMMANDS": "ON"
      }
    },
    {
      "name": "debug",
      "inherits": "base",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "CMAKE_CXX_FLAGS": "-fsanitize=address,undefined"
      }
    },
    {
      "name": "release",
      "inherits": "base",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Release",
        "CMAKE_INTERPROCEDURAL_OPTIMIZATION": "ON"
      }
    }
  ],
  "buildPresets": [
    { "name": "debug", "configurePreset": "debug" },
    { "name": "release", "configurePreset": "release" }
  ],
  "testPresets": [
    {
      "name": "debug",
      "configurePreset": "debug",
      "output": { "verbosity": "verbose" }
    }
  ]
}
```

**Workflow:**

```bash
cmake --preset debug          # Configure
cmake --build --preset debug  # Build
ctest --preset debug          # Test
```

## Targets

```cmake
add_library(mylib STATIC)  # or SHARED, INTERFACE

target_sources(mylib
    PRIVATE src/foo.cpp src/bar.cpp
    PUBLIC  include/mylib/api.hpp)

target_include_directories(mylib
    PUBLIC  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
            $<INSTALL_INTERFACE:include>
    PRIVATE src/)

target_compile_features(mylib PUBLIC cxx_std_23)

target_compile_options(mylib PRIVATE
    $<$<CXX_COMPILER_ID:Clang,GNU>:-Wall -Wextra -Wpedantic -Wshadow>
    $<$<CXX_COMPILER_ID:MSVC>:/W4>)

target_link_libraries(mylib PUBLIC dep1 PRIVATE dep2)
```

**Visibility rules:**

- `PRIVATE` — used only when building this target.
- `PUBLIC` — used when building this target AND propagated to consumers.
- `INTERFACE` — not used here; propagated to consumers only (for header-only libs).

## Dependency Management

### FetchContent (preferred for pinned deps)

```cmake
include(FetchContent)
FetchContent_Declare(catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2.git
    GIT_TAG        v3.7.1
    SYSTEM)  # Suppresses warnings from dep headers
FetchContent_MakeAvailable(catch2)
```

Always pin to a tag or commit hash — never `main`/`master`.

### find_package (system / vcpkg / Conan)

```cmake
find_package(OpenSSL 3.0 REQUIRED)
target_link_libraries(mylib PRIVATE OpenSSL::SSL OpenSSL::Crypto)
```

Use `REQUIRED` unless the dependency is truly optional; in that case check `<Package>_FOUND`.

### vcpkg Integration

```cmake
# In CMakePresets.json toolchainFile:
"toolchainFile": "$env{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
```

## Compiler Warnings (cmake/CompilerWarnings.cmake)

```cmake
function(target_enable_warnings target)
    target_compile_options(${target} PRIVATE
        $<$<CXX_COMPILER_ID:Clang,AppleClang>:
            -Wall -Wextra -Wpedantic -Wshadow -Wconversion
            -Wnon-virtual-dtor -Woverloaded-virtual
            -Wmissing-prototypes>
        $<$<CXX_COMPILER_ID:GNU>:
            -Wall -Wextra -Wpedantic -Wshadow -Wconversion
            -Wnon-virtual-dtor -Woverloaded-virtual
            -Wmisleading-indentation>
        $<$<CXX_COMPILER_ID:MSVC>:
            /W4 /permissive->)
endfunction()
```

## clang-tidy Integration

```cmake
set(CMAKE_CXX_CLANG_TIDY
    clang-tidy
    --checks=cppcoreguidelines-*,modernize-*,bugprone-*,performance-*
    --warnings-as-errors=*)
```

Or per-target: `set_target_properties(mylib PROPERTIES CXX_CLANG_TIDY "${CLANG_TIDY_COMMAND}")`.

## Testing

```cmake
find_package(Catch2 3 REQUIRED)
include(CTest)
include(Catch)

add_executable(tests test/foo_test.cpp)
target_link_libraries(tests PRIVATE mylib Catch2::Catch2WithMain)
catch_discover_tests(tests)
```

## Mixed-Language Projects

### JUCE

See `juce-expert` skill. Use `juce_add_plugin` / `juce_add_gui_app` macros — they wrap `add_executable`/`add_library` with JUCE-specific scaffolding.

### Zig Libraries

```cmake
# Build a Zig static lib as a custom target
add_custom_target(zig_lib
    COMMAND zig build-lib src/algo.zig
            -target x86_64-macos
            -O ReleaseFast
            --name zig_algo
    BYPRODUCTS ${CMAKE_BINARY_DIR}/libzig_algo.a
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_library(zig_algo STATIC IMPORTED)
set_target_properties(zig_algo PROPERTIES
    IMPORTED_LOCATION ${CMAKE_BINARY_DIR}/libzig_algo.a)
add_dependencies(zig_algo zig_lib)

target_link_libraries(mylib PRIVATE zig_algo)
```

### Mojo / Modular Libraries

Build Mojo code to a shared lib via `mojo build --emit-shared-library`, then link as `SHARED IMPORTED` the same way as Zig above.

## Build System Landscape

| Tool              | Role                                      | When to use                                                      |
| :---------------- | :---------------------------------------- | :--------------------------------------------------------------- |
| **CMake**         | Meta build system (generates build files) | Default for all C++ projects                                     |
| **Ninja**         | Build executor                            | Always use as CMake backend (`-G Ninja`)                         |
| **Make**          | Build executor (legacy)                   | Avoid; use Ninja                                                 |
| **Meson**         | Meta build system                         | FOSS/Linux projects not using CMake; not supported by JUCE       |
| **Bazel / Buck2** | Monorepo build systems                    | Large orgs with monorepos; overkill for most                     |
| **xmake**         | Meta build system                         | Niche; avoid unless the project already uses it                  |
| **Zig build**     | Build system for Zig; can compile C/C++   | Use if Zig is the primary language or as a cross-compiler driver |

**SOTA for C++ audio/plugin work:** CMake + Ninja. Everything else is a special case.

## Useful Commands

```bash
# Configure + build
cmake --preset debug
cmake --build --preset debug --parallel

# Verbose build (see compiler invocations)
cmake --build --preset debug --verbose

# List all targets
cmake --build --preset debug --target help

# Install
cmake --install build/release --prefix /usr/local

# Generate compile_commands.json (for clangd/clang-tidy)
# Handled automatically via CMAKE_EXPORT_COMPILE_COMMANDS=ON in preset

# Check what a target links against
cmake --graphviz=deps.dot build/debug && dot -Tpng deps.dot -o deps.png
```
