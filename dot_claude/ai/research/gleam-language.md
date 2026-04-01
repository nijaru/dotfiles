# Gleam Language Research

**Date:** 2026-03-31
**Purpose:** Foundation for a Gleam expert coding skill
**Sources:** Context7 (gleam-lang/gleam, gleam-lang/otp, gleam_stdlib), official docs, changelogs

---

## 1. Version and Release History

- **v1.0.0**: March 2024 — first stable release
- **v1.5**: September 2024 — productivity enhancements, better compile-time messages
- **v1.7**: `@deprecated` on type variants; convert callback → `use` expression code action
- **v1.8**: Language server suggests "pattern match on variable" code action
- **v1.10**: Warn on redundant `let assert`; replace spread `..` with named fields code action
- **v1.11**: `assert` for boolean runtime checks
- **v1.13**: JS target generates public API for FFI against custom types; JS custom type constructors/accessors
- **v1.14** (December 2025 — current): Record update syntax for constants; external type annotations; number normalization; interference-based int pruning; type-directed autocompletion; `gleam deps outdated`; warn on redundant modules; warn on detached doc comments

---

## 2. Core Philosophy and Design Principles

**Explicit over implicit.** No hidden control flow, no exceptions, no nulls, no implicit conversions.

**Small, cohesive language.** Intentionally excludes:

- `if` expressions (use `case` instead — compiler error tells you this)
- `for`/`while` loops (use recursion or `list.map`/`list.fold`/`list.each`)
- Exceptions (use `Result`)
- Null / nil values (use `Option`)
- Type classes
- Macros
- Function overloading
- Implicit arguments
- Mutation
- Object orientation
- Inheritance

**Impure functional.** Like OCaml or Erlang — IO and side effects are permitted without special handling (no monadic IO).

**Friendly error messages.** Compiler messages are a first-class feature; error quality is a design goal.

**Types erased at runtime.** Zero overhead — no runtime type checks.

**Division by zero returns 0.** Not an exception, not infinity. Deliberate choice because BEAM has no infinity and Gleam avoids implicit exceptions.

---

## 3. Type System

### Primitive Types

```gleam
// Integers — arbitrary precision on BEAM, 64-bit on JS
let x: Int = 42
let hex = 0xFF
let octal = 0o77
let binary = 0b1010
let big = 1_000_000

// Floats — always have decimal point
let f: Float = 3.14
let sci = 1.0e10

// Strings — UTF-8, double quotes only
let s: String = "hello"
let concat = "hello" <> " world"   // <> is concat, not +

// Booleans — True/False (capitalized)
let b: Bool = True

// Nil — unit type, only value is Nil
let n: Nil = Nil
```

### Custom Types

Custom types are the primary data modeling tool. They unify what other languages call enums, structs, and tagged unions.

```gleam
// Sum type (enum-like)
pub type Direction {
  North
  South
  East
  West
}

// Product type (struct-like) — variant with fields is called a "record"
pub type Point {
  Point(x: Float, y: Float)
}

// Sum type with data
pub type Shape {
  Circle(radius: Float)
  Rectangle(width: Float, height: Float)
  Triangle(base: Float, height: Float)
}

// Record access
let p = Point(x: 1.0, y: 2.0)
let x = p.x   // field access via dot notation

// Record update — creates new value
let p2 = Point(..p, y: 3.0)
```

### Opaque Types

Constructors hidden from other modules; only the module defining the type can construct/destructure it. Used for abstract data types with invariants.

```gleam
pub opaque type Email {
  Email(String)
}

pub fn create(value: String) -> Result(Email, String) {
  case string.contains(value, "@") {
    True -> Ok(Email(value))
    False -> Error("Invalid email")
  }
}
```

### Type Aliases

```gleam
pub type UserId = Int
pub type Name = String
```

### Generics

Type parameters are lowercase single letters or descriptive names.

```gleam
pub type Box(value) {
  Box(value: value)
}

pub type Result(ok_type, error_type) {  // built-in, defined this way
  Ok(ok_type)
  Error(error_type)
}

pub fn map_box(box: Box(a), f: fn(a) -> b) -> Box(b) {
  Box(f(box.value))
}
```

### Option Type

```gleam
// Defined in gleam/option — must import
import gleam/option.{type Option, None, Some}

pub type Option(a) {
  Some(a)
  None
}
```

Note: `Option` is NOT in the prelude. You must import it. This trips up Elixir devs who expect `nil` to just work.

### Result Type

```gleam
// In prelude — available without import
// Ok(value) and Error(reason) constructors available everywhere

pub type Result(value, error) {
  Ok(value)
  Error(error)
}
```

### Constants

```gleam
pub const max_retries: Int = 3
pub const default_host: String = "localhost"

// v1.14+: record update in constants
pub const base_config = Config(host: "localhost", port: 8080)
pub const prod_config = Config(..base_config, port: 443)
```

---

## 4. Pattern Matching

`case` is the only conditional construct. Exhaustiveness is checked at compile time.

```gleam
// Basic matching
case direction {
  North -> "Going north"
  South -> "Going south"
  _ -> "Other direction"
}

// Matching with bindings
case shape {
  Circle(radius) -> float.pi *. radius *. radius
  Rectangle(w, h) -> w *. h
  Triangle(b, h) -> b *. h /. 2.0
}

// Named fields in patterns (shorthand: field: = field: field)
case user {
  Admin(name:, permissions:) -> "Admin: " <> name   // name: binds name to 'name'
  Guest(name:) -> "Guest: " <> name
  Anonymous -> "Stranger"
}

// Guards
case n {
  0 -> "zero"
  n if n < 0 -> "negative"
  n if n > 100 -> "large"
  _ -> "normal"
}

// Multiple patterns (alternative patterns with |)
case x {
  1 | 2 | 3 -> "small"
  _ -> "other"
}

// Tuple patterns
case #(x, y) {
  #(0, 0) -> "origin"
  #(x, 0) -> "x-axis at " <> int.to_string(x)
  _ -> "somewhere else"
}

// List patterns
case items {
  [] -> "empty"
  [first] -> "one: " <> first
  [first, ..rest] -> "many, starting with " <> first
}

// Nested patterns
case result {
  Ok(Some(value)) -> value
  Ok(None) -> "nothing"
  Error(msg) -> "error: " <> msg
}

// String prefix patterns
case str {
  "https://" <> rest -> Ok(rest)
  _ -> Error("not https")
}
```

### let for Irrefutable Patterns

```gleam
let Point(x:, y:) = point    // only valid if single-variant type
let #(a, b) = my_tuple
```

### let assert for Panicking Assertions

For places where you're certain a pattern will match; panics at runtime if it doesn't. Used in tests and "impossible" branches, not for error handling.

```gleam
let assert Ok(value) = some_operation()
let assert [first, ..] = non_empty_list
```

The compiler warns if the assertion is statically proven redundant (v1.10+).

---

## 5. Functions

```gleam
// Basic function
pub fn add(a: Int, b: Int) -> Int {
  a + b
}

// Return type is the last expression (no return keyword)
pub fn greet(name: String) -> String {
  "Hello, " <> name
}
```

### Labeled Arguments

External label (call site) and internal name (function body) can differ.

```gleam
pub fn create_greeting(for name: String, from sender: String) -> String {
  "Hello " <> name <> ", from " <> sender
}

// Call with labels
create_greeting(for: "Alice", from: "Bob")

// Labels can be passed in any order at call site
create_greeting(from: "Bob", for: "Alice")
```

### Anonymous Functions

```gleam
let double = fn(x: Int) -> Int { x * 2 }
let add = fn(a, b) { a + b }   // types inferred
```

### Function Captures

Partial application using `_` as placeholder.

```gleam
let add_five = int.add(_, 5)    // fn(Int) -> Int
let double = int.multiply(2, _) // fn(Int) -> Int

// Common in pipelines
[1, 2, 3]
|> list.map(int.multiply(_, 2))
```

### Pipeline Operator `|>`

Passes left side as the first argument to the right side.

```gleam
// Without pipeline
list.fold(list.filter(list.map(numbers, double), is_even), 0, int.add)

// With pipeline (read top-to-bottom)
numbers
|> list.map(double)
|> list.filter(is_even)
|> list.fold(0, int.add)
```

The pipeline passes as first argument. When you need a different position, use a capture:

```gleam
"hello world"
|> string.split(_, " ")   // explicit _ placement when not first arg
// or
|> fn(s) { string.split(s, " ") }
```

### Higher-Order Functions

Functions are first-class values.

```gleam
pub fn apply(f: fn(Int) -> Int, x: Int) -> Int {
  f(x)
}

pub fn compose(f: fn(b) -> c, g: fn(a) -> b) -> fn(a) -> c {
  fn(x) { f(g(x)) }
}
```

### No Default Arguments

Gleam has no default argument values. Use labeled arguments with wrapper functions, or use `Option` parameters explicitly.

---

## 6. Modules and Imports

**One module per file.** The module name is derived from its file path relative to `src/`.

- `src/my_app/user.gleam` → module name `my_app/user`
- Module paths use `/`, not `.`

```gleam
// Import entire module — access via module.function
import gleam/io
import gleam/list
import gleam/string

io.println("hello")
list.map([1, 2, 3], fn(x) { x * 2 })

// Import with alias
import gleam/string as str
str.length("hello")

// Import specific values/types (unqualified access)
import gleam/option.{type Option, None, Some}
import gleam/result.{type Result, try}

// Unqualified after import
Some(42)
None
```

### Visibility

```gleam
// Public — accessible from other modules
pub fn my_function() { ... }
pub type MyType { ... }
pub const my_const = 42

// Private (default) — module-internal only
fn helper() { ... }
type InternalType { ... }
const internal = 0

// Opaque public type — type visible, constructors private
pub opaque type Token { Token(String) }
```

### No Circular Imports

Gleam enforces a strict DAG of module dependencies. Circular imports are a compile error.

---

## 7. Error Handling

### Result Type (Primary Pattern)

```gleam
// Result is in the prelude
pub type Result(value, error) {
  Ok(value)
  Error(error)
}
```

### Chaining with `result.try`

```gleam
import gleam/result

pub fn process(input: String) -> Result(Int, String) {
  use n <- result.try(parse_int(input))
  use validated <- result.try(validate_range(n))
  Ok(validated * 2)
}
```

### The `use` Expression

Syntactic sugar for callback-heavy code. Desugars to a function call with a trailing callback.

```gleam
// These are equivalent:
use profile <- result.try(fetch_profile(user))
render_welcome(user, profile)

// Desugars to:
result.try(fetch_profile(user), fn(profile) {
  render_welcome(user, profile)
})
```

`use` works with any function that takes a callback as its last argument:

```gleam
// With custom higher-order functions
use conn <- with_db_connection()
use row <- db.each(query, conn)
process_row(row)

// Combining multiple error types
pub fn load_config() -> Result(Config, ConfigError) {
  use raw <- result.try(read_file("config.json") |> result.map_error(FileError))
  use parsed <- result.try(json.decode(raw) |> result.map_error(ParseError))
  Ok(Config(parsed))
}
```

### Key result module functions

```gleam
result.try(result, fn(value) { ... })   // flatMap
result.map(result, fn(value) { ... })   // map Ok
result.map_error(result, fn(e) { ... }) // map Error
result.unwrap(result, default)          // extract or default
result.lazy_unwrap(result, fn() { default() })
result.is_ok(result)                    // Bool
result.is_error(result)                 // Bool
result.all(list_of_results)             // Result(List, E) — first error
result.flatten(nested_result)           // Result(Result(a,e),e) -> Result(a,e)
result.try_recover(result, fn(e) { ... }) // Error -> Result
result.or(first, fallback)
result.lazy_or(first, fn() { fallback() })
```

### `panic` and `todo`

```gleam
panic as "unreachable: invariant violated"  // Runtime panic
todo as "implement this later"              // Compile/runtime placeholder
// Both cause runtime crashes
// todo is treated as a warning at compile time
```

**Anti-pattern:** using `panic` for error handling. Use `Result` instead.

---

## 8. Standard Library

Standard library modules must be imported. Nothing beyond `Ok`/`Error`/`Bool`/`True`/`False`/`Nil`/`Int`/`Float`/`String`/`List` is in the prelude.

### gleam/io

```gleam
io.println(string)         // print with newline to stdout
io.print(string)           // print without newline to stdout
io.println_error(string)   // stderr with newline
io.print_error(string)     // stderr without newline
io.debug(value)            // prints any value with Debug representation, returns it
```

### gleam/string

```gleam
string.length(s)
string.reverse(s)
string.uppercase(s) / string.lowercase(s)
string.trim(s) / string.trim_start(s) / string.trim_end(s)
string.split(s, on: delimiter)
string.join(list, with: separator)
string.contains(does: haystack, contain: needle)  // labeled args
string.starts_with(s, prefix) / string.ends_with(s, suffix)
string.replace(in: s, each: old, with: new)
string.slice(s, at_index: i, length: n)
string.pad_start(s, to: n, with: char) / string.pad_end(...)
string.to_int(s) -> Result(Int, Nil)  // use int.parse instead
string.inspect(value)  // any value to debug string
string.byte_size(s)    // bytes, not characters
string.concat(list)    // join without separator
```

### gleam/int

```gleam
int.to_string(n)
int.parse(s) -> Result(Int, Nil)
int.absolute_value(n)
int.clamp(n, min:, max:)
int.max(a, b) / int.min(a, b)
int.power(base, exponent: Float) -> Result(Float, Nil)
int.square_root(n) -> Result(Float, Nil)
int.to_float(n) -> Float
int.remainder(dividend, divisor) -> Result(Int, Nil)
int.modulo(dividend, divisor) -> Result(Int, Nil)
int.add(a, b)  // useful in pipelines
int.multiply(a, b)
int.compare(a, b) -> Order
int.digits(n, base) -> Result(List(Int), Nil)
int.undigits(digits, base) -> Result(Int, Nil)
int.to_base_string(n, base) -> Result(String, Nil)
int.random(n) -> Int  // 0..n-1
```

### gleam/float

```gleam
float.to_string(f)
float.parse(s) -> Result(Float, Nil)
float.ceiling(f) / float.floor(f) / float.round(f) -> Int
float.truncate(f) -> Int
float.absolute_value(f)
float.power(base, exponent) -> Result(Float, Nil)
float.square_root(f) -> Result(Float, Nil)
float.max(a, b) / float.min(a, b)
float.compare(a, b) -> Order
// Note: float arithmetic uses *. /. +. -. operators
```

**Critical:** Int and Float operators are different. `+` is Int, `+.` is Float. No implicit conversion.

```gleam
1 + 2     // Int
1.0 +. 2.0  // Float
// 1 + 2.0  ERROR — type mismatch
int.to_float(1) +. 2.0  // must convert explicitly
```

### gleam/list

```gleam
list.map(list, fn(x) { ... })
list.filter(list, fn(x) { ... })
list.fold(list, initial, fn(acc, x) { ... })
list.fold_right(list, initial, fn(acc, x) { ... })
list.each(list, fn(x) { ... }) -> Nil   // side effects
list.flat_map(list, fn(x) { ... })
list.flatten(list_of_lists)
list.length(list)
list.first(list) -> Result(a, Nil)
list.last(list) -> Result(a, Nil)
list.rest(list) -> Result(List(a), Nil)
list.append(a, b)  // a ++ b equivalent
list.concat(lists)
list.reverse(list)
list.sort(list, by: compare_fn)
list.take(list, up_to: n)
list.drop(list, up_to: n)
list.zip(a, b) -> List(#(a, b))
list.unzip(pairs) -> #(List(a), List(b))
list.any(list, fn(x) { ... }) -> Bool
list.all(list, fn(x) { ... }) -> Bool
list.find(list, fn(x) { ... }) -> Result(a, Nil)
list.index_map(list, fn(x, i) { ... })
list.unique(list)
list.contains(list, item) -> Bool
list.count(list, fn(x) { ... }) -> Int
list.group(list, by: fn(x) { ... }) -> Dict(key, List(value))
list.range(from: start, to: end) -> List(Int)
list.repeat(item, times: n) -> List(a)
list.sized_chunk(list, into: n)
list.split(list, at: n) -> #(List(a), List(a))
list.try_map(list, fn(x) { ... }) -> Result(List(b), e)  // stops on first Error
list.try_fold(...)
```

**Note:** Lists are singly-linked. Prepend `[x, ..list]` is O(1), append is O(n).

### gleam/option

```gleam
import gleam/option.{type Option, Some, None}

option.map(opt, fn(x) { ... })
option.then(opt, fn(x) { ... })        // flatMap
option.unwrap(opt, default)
option.lazy_unwrap(opt, fn() { ... })
option.is_some(opt) -> Bool
option.is_none(opt) -> Bool
option.from_result(result) -> Option   // Ok(x) -> Some(x), Error -> None
option.to_result(opt, error) -> Result
option.values(list_of_options) -> List  // filters Nones
option.all(list_of_options) -> Option(List)
```

### gleam/result (already covered in section 7)

### gleam/dict

```gleam
import gleam/dict.{type Dict}

dict.new() -> Dict(k, v)
dict.from_list(list_of_pairs) -> Dict(k, v)
dict.to_list(dict) -> List(#(k, v))
dict.insert(dict, key, value) -> Dict(k, v)
dict.get(dict, key) -> Result(v, Nil)
dict.delete(dict, key) -> Dict(k, v)
dict.has_key(dict, key) -> Bool
dict.keys(dict) -> List(k)          // unordered
dict.values(dict) -> List(v)        // unordered
dict.size(dict) -> Int
dict.map_values(dict, fn(k, v) { ... }) -> Dict(k, new_v)
dict.filter(dict, fn(k, v) { ... }) -> Dict(k, v)
dict.merge(dict_a, dict_b)          // b wins on conflict
dict.upsert(dict, key, fn(opt) { ... })  // update or insert
dict.fold(dict, initial, fn(acc, k, v) { ... })
dict.combine(a, b, fn(v1, v2) { ... })  // merge with conflict resolution
dict.each(dict, fn(k, v) { ... }) -> Nil
dict.take(dict, keeping: list_of_keys) -> Dict(k, v)
dict.drop(dict, discard: list_of_keys) -> Dict(k, v)
```

### gleam/set (via gleam_stdlib)

```gleam
import gleam/set.{type Set}
set.new() / set.from_list(list) / set.to_list(set)
set.insert(set, value) / set.delete(set, value)
set.contains(set, value) -> Bool
set.union(a, b) / set.intersection(a, b) / set.difference(a, b)
set.size(set)
```

### gleam/order

```gleam
import gleam/order.{type Order, Lt, Eq, Gt}
// Used by sort functions
order.negate(order) -> Order
order.compare(a: Order, b: Order) -> Order
```

---

## 9. OTP Interop (gleam_otp)

Separate package: `gleam add gleam_otp gleam_erlang`

### Actors (gen_server equivalent)

```gleam
import gleam/otp/actor
import gleam/erlang/process.{type Subject}

pub type Message {
  Increment
  GetCount(Subject(Int))   // Subject is a typed mailbox reference
}

pub fn start() {
  actor.new(0)
  |> actor.on_message(fn(state, msg) {
    case msg {
      Increment -> actor.continue(state + 1)
      GetCount(reply) -> {
        process.send(reply, state)
        actor.continue(state)
      }
    }
  })
  |> actor.start
}

// Sending messages
process.send(subject, Increment)

// Call (send + wait for reply)
let count = actor.call(subject, waiting: 1000, sending: GetCount)
```

### Key actor returns

```gleam
actor.continue(new_state)          // continue with new state
actor.stop()                        // graceful stop
actor.stop_with_error(reason)       // stop with error reason
```

### Supervisors

```gleam
import gleam/otp/static_supervisor as supervisor
import gleam/otp/supervision

supervisor.new(supervisor.OneForOne)  // or RestForOne, OneForAll
|> supervisor.add(supervision.worker(start_fn))
|> supervisor.restart_tolerance(intensity: 5, period: 60)
|> supervisor.start
```

### Subjects vs Pids

- `Subject(msg_type)` — typed, Gleam-specific, can only send `msg_type`
- `process.Pid` — untyped Erlang process ID
- Always prefer `Subject` in Gleam code

### Named Actors

```gleam
let name = process.new_name("my_counter")
actor.new(0)
|> actor.named(name)
|> actor.start

let subject = process.named_subject(name)
```

### Process Monitoring

```gleam
import gleam/erlang/process

process.monitor_process(pid)    // receive Down message if it exits
process.link(pid)               // linked processes — crash together
process.self() -> Pid
process.sleep(milliseconds)
```

---

## 10. JavaScript vs Erlang Target Differences

### Setting Target

```toml
# gleam.toml
target = "erlang"   # default
target = "javascript"
```

Or override per command:

```bash
gleam build --target javascript
gleam run --target javascript --runtime nodejs  # or deno, bun
gleam test --target javascript --runtime bun
```

### Data Representation Differences

| Type                       | Erlang                          | JavaScript         |
| -------------------------- | ------------------------------- | ------------------ |
| String                     | UTF-8 binary `<<"hello"/utf8>>` | Native JS string   |
| Int                        | Arbitrary precision             | 64-bit JS number   |
| Float                      | IEEE 754                        | Native JS number   |
| Atom                       | Erlang atom                     | String             |
| Bool                       | Erlang atoms `true`/`false`     | JS `true`/`false`  |
| Nil                        | `nil` atom                      | `undefined`        |
| Result `Ok(x)`             | `{ok, X}` tuple                 | Constructor object |
| Result `Error(e)`          | `{error, E}` tuple              | Constructor object |
| List                       | Erlang linked list              | Gleam list object  |
| Tuple                      | Erlang tuple                    | Array              |
| Dict                       | Erlang map                      | JS Map             |
| Custom types (fieldless)   | Atom                            | String             |
| Custom types (with fields) | Tagged tuple                    | Constructor object |

### Target-Specific Code with @target

```gleam
@target(erlang)
pub fn platform() -> String {
  "erlang"
}

@target(javascript)
pub fn platform() -> String {
  "javascript"
}
```

### FFI Differences

```gleam
// Erlang FFI
@external(erlang, "erlang", "system_time")
pub fn system_time(unit: Atom) -> Int

// Elixir module — prefix with Elixir.
@external(erlang, "Elixir.SomeModule", "some_function")
pub fn call_elixir() -> String

// JavaScript FFI — relative path to .mjs file
@external(javascript, "./ffi.mjs", "getCurrentTime")
pub fn current_time() -> Int

// Both targets
@external(erlang, "rand", "uniform")
@external(javascript, "./ffi.mjs", "random")
pub fn random_float() -> Float
```

**JavaScript FFI requirements:**

- File must be `.mjs` (ES module)
- Gleam types have a JS public API (v1.13+): `Result$Ok(v)`, `Result$Error(e)`, `List$Empty()`, `List$NonEmpty(head, tail)`, `TypeName$VariantName(fields)`

### OTP on JavaScript

OTP/actors only available on Erlang target. `gleam_otp` and `gleam_erlang` are Erlang-only packages.

### TypeScript Declarations

```toml
[javascript]
typescript_declarations = true  # generates .d.ts files
```

---

## 11. Build Tool (gleam CLI)

```bash
# Project management
gleam new my_project           # scaffold new project
gleam new my_project --template lib   # library template

# Build
gleam build                    # compile project
gleam build --target erlang
gleam build --target javascript
gleam build --warnings-as-errors

# Run
gleam run                      # runs main module
gleam run --module my_module   # specific module
gleam run --target javascript --runtime bun
gleam run -- arg1 arg2         # pass args to program

# Test
gleam test
gleam test --target javascript --runtime bun

# Dev mode
gleam dev                      # runs <project>_dev module

# Format
gleam format                   # format all .gleam files
gleam format --check           # CI check, no writes

# Dependencies (Hex package manager)
gleam add gleam_json           # add dependency
gleam add gleam_json@2         # specific version
gleam add --dev gleeunit       # dev dependency
gleam remove package_name
gleam deps list
gleam deps download
gleam deps outdated            # show available updates (v1.14+)
gleam deps tree
gleam update                   # update all to latest compatible
gleam update lustre            # update specific package

# Publishing to Hex
gleam publish
gleam publish --yes            # skip confirmation
gleam hex authenticate
gleam hex retire pkg version reason "message"

# LSP (for editors)
gleam lsp                      # start language server
```

### gleam.toml Structure

```toml
name = "my_project"
version = "0.1.0"
target = "erlang"    # optional, default is erlang

[dependencies]
gleam_stdlib = ">= 0.44.0 and < 2.0.0"
gleam_json = "~> 2.0"

[dev-dependencies]
gleeunit = ">= 1.0.0 and < 2.0.0"

[erlang]
application_start_module = "my_project/application"
extra_applications = ["inets", "ssl"]

[javascript]
typescript_declarations = true
runtime = "nodejs"
```

### Project Structure

```
my_project/
  gleam.toml
  src/
    my_project.gleam       # main module (same name as project)
    my_project/
      user.gleam           # module: my_project/user
      database.gleam       # module: my_project/database
  test/
    my_project_test.gleam  # test module
```

---

## 12. Package Manager (Hex)

Gleam uses Hex, shared with Erlang and Elixir ecosystems.

- Hex packages can contain Gleam, Erlang, and Elixir code
- Gleam can call Erlang/Elixir hex packages via FFI
- Version constraints: `">= 1.0.0 and < 2.0.0"` or `"~> 1.0"` (compatible)
- Lock file: `manifest.toml` (commit this)

Common packages:

- `gleam_stdlib` — standard library (always needed)
- `gleeunit` — testing
- `gleam_otp` — actors/supervisors
- `gleam_erlang` — Erlang-specific types/functions
- `gleam_json` — JSON encoding/decoding
- `lustre` — frontend/full-stack web framework
- `wisp` — web framework (server-side)
- `mist` — HTTP server
- `squirrel` — SQL with compile-time validation

---

## 13. Testing (gleeunit)

```gleam
// test/my_project_test.gleam
import gleeunit
import gleeunit/should
import my_project

pub fn main() {
  gleeunit.main()
}

// Test functions MUST end with _test
pub fn addition_test() {
  1 + 1
  |> should.equal(2)
}

pub fn my_function_test() {
  my_project.some_fn(42)
  |> should.equal(Ok("expected"))
}

pub fn error_test() {
  my_project.failing_fn()
  |> should.be_error()
}

// should functions
should.equal(actual, expected)
should.not_equal(actual, expected)
should.be_ok(result)
should.be_error(result)
should.be_some(option)
should.be_none(option)
should.be_true(bool)
should.be_false(bool)
```

### assert keyword (v1.11+)

Works in tests and production code:

```gleam
assert some_fn() == expected_value
assert result.is_ok(something) as "operation should succeed"
```

### let assert in tests

```gleam
let assert Ok(value) = fallible_operation()
let assert [first, ..] = non_empty_result
```

### Running tests

```bash
gleam test                              # Erlang target
gleam test --target javascript --runtime bun
```

---

## 14. Naming Conventions

**Everything is snake_case in Gleam.** The only exception is type names and variant (constructor) names, which are PascalCase.

| Item            | Convention         | Example                                |
| --------------- | ------------------ | -------------------------------------- |
| Modules         | `snake_case` paths | `my_app/user_profile`                  |
| Functions       | `snake_case`       | `get_user`, `parse_config`             |
| Variables       | `snake_case`       | `user_name`, `max_count`               |
| Constants       | `snake_case`       | `max_retries`, `default_host`          |
| Type names      | `PascalCase`       | `UserId`, `ParseError`                 |
| Type variants   | `PascalCase`       | `Ok`, `Error`, `Some`, `None`, `North` |
| Type parameters | `lowercase`        | `a`, `b`, `value`, `error_type`        |
| Labels          | `snake_case`       | `for:`, `from:`, `with:`               |
| Test functions  | `snake_case_test`  | `parse_user_test`                      |

**No atoms in user code.** Elixir devs: there are no `:atoms`. Variants/constructors serve the same role.

---

## 15. What's Idiomatic vs What's an Elixir/Erlang Habit That Doesn't Translate

### Things That Do NOT Exist in Gleam

| Missing Feature                    | What to Do Instead                                     |
| ---------------------------------- | ------------------------------------------------------ |
| `if` expression                    | `case condition { True -> ... False -> ... }`          |
| `for`/`while` loops                | `list.map`, `list.fold`, `list.each`, recursion        |
| Exceptions / `try..rescue`         | `Result` type                                          |
| `nil` / `null`                     | `Option` type (`Some`/`None`)                          |
| Atoms (`:ok`, `:error`)            | Custom type variants (`Ok`, `Error`)                   |
| Erlang atoms as dict keys          | Any type as dict key                                   |
| Pattern matching in function heads | `case` in function body                                |
| Multiple function clauses          | Single function + `case`                               |
| Guard clauses at function level    | Guards inside `case`                                   |
| `with` (Elixir)                    | `use` expression                                       |
| Macros                             | No equivalent (intentional)                            |
| Protocols (Elixir)                 | No equivalent (intentional)                            |
| Behaviours (Erlang)                | Use regular modules/callbacks                          |
| `@moduledoc` / `@doc`              | `///` doc comments                                     |
| Strings as char lists              | No char lists — always UTF-8 binary strings            |
| String interpolation `"#{var}"`    | Concatenation `"hello " <> name` or `string.concat`    |
| `IO.inspect/1` debugging           | `io.debug(value)` (returns value, usable in pipelines) |
| Sigils `~r`, `~s`                  | No sigils                                              |

### Pattern Matching Differences from Elixir/Erlang

```gleam
// NO function-level pattern matching:
// pub fn greet(User(name:)) -> ... // INVALID

// YES — case in body:
pub fn greet(user: User) -> String {
  case user {
    User(name:) -> "Hello " <> name
  }
}

// NO multiple function heads:
// pub fn fib(0) { 0 }
// pub fn fib(1) { 1 }
// pub fn fib(n) { fib(n-1) + fib(n-2) }

// YES:
pub fn fib(n: Int) -> Int {
  case n {
    0 -> 0
    1 -> 1
    n -> fib(n - 1) + fib(n - 2)
  }
}
```

### Specific Erlang Habits That Break

```gleam
// WRONG — Erlang-style atom result
// {:ok, value} doesn't exist in Gleam

// WRONG — using _ for "don't care" in variable names
// Gleam uses _ as prefix convention: _unused_var
// Standalone _ in patterns is fine

// WRONG — bare values in case branches without ->
// Gleam always needs ->

// WRONG — pipe to non-first-argument position silently
// result |> some_fn(extra_arg)  // extra_arg is SECOND, result is FIRST
// Use capture: result |> some_fn(extra_arg, _)  // No — wrong
// Use: result |> fn(r) { some_fn(extra_arg, r) }
// Or: some_fn(extra_arg, result)  // clearest

// WRONG — assuming Elixir's `with` syntax
// use is similar but not identical
```

### Specific Anti-Patterns in Gleam

1. **Using `panic`/`let assert` for error handling.** These are for "impossible" states. Use `Result` and propagate errors.

2. **Ignoring the `Error` branch.** The compiler enforces exhaustive matching, but ignoring errors with `_` discards them silently.

3. **Deeply nested `case` without `use`.** Pyramid of doom with Result chains. Use `use` expression.

4. **Not using labeled arguments.** Functions with multiple same-type args (e.g., `fn(String, String, String)`) become confusing. Label them.

5. **String building with many `<>`.** Use `string.concat` or build a list and `string.join` for many strings.

6. **Trying to mutate.** No variables are mutable. Use recursion with accumulator, or fold.

7. **Missing `import` for `Option`/`Some`/`None`.** These are NOT in the prelude. Always import.

8. **Using `todo` in production code.** It compiles but panics at runtime. Use proper error types.

9. **Overusing `let assert`.** Great in tests, dangerous in production paths.

10. **Not handling `gleam/option` vs `gleam/result` correctly.** `option.from_result`/`option.to_result` bridge between them.

11. **Forgetting `. ` (dot) arithmetic for floats.** `1 + 2.0` is a type error. Must use `1.0 +. 2.0` or `int.to_float(1) +. 2.0`.

12. **String prefix patterns on JS target.** The `"prefix" <> rest` string pattern works on Erlang but has limitations on JS target — be careful with cross-target code.

### What's Idiomatic

```gleam
// 1. Pipeline-first style for data transformations
users
|> list.filter(fn(u) { u.active })
|> list.map(fn(u) { u.name })
|> string.join(with: ", ")

// 2. use expression for Result chains
pub fn handle_request(id: String) -> Result(Response, AppError) {
  use user_id <- result.try(parse_id(id))
  use user <- result.try(fetch_user(user_id))
  use perms <- result.try(check_permissions(user))
  Ok(build_response(user, perms))
}

// 3. Opaque types for domain modeling
pub opaque type UserId {
  UserId(Int)
}
pub fn new_user_id(n: Int) -> Result(UserId, String) { ... }

// 4. Labeled arguments for clarity
pub fn send_email(
  to recipient: String,
  from sender: String,
  subject subject_line: String,
) -> Result(Nil, EmailError)

// 5. Custom error types as sum types
pub type DatabaseError {
  ConnectionFailed(String)
  QueryFailed(String)
  NotFound
}

// 6. io.debug in pipelines (returns value)
value
|> io.debug  // prints, passes through
|> next_step

// 7. Shorthand field labels (v1.x)
// When label name == variable name:
let name = "Alice"
User(name:)  // equivalent to User(name: name)

// Same in patterns:
case user {
  User(name:) -> name  // binds field 'name' to var 'name'
}
```

---

## 16. Bit Arrays

Gleam's low-level binary data type. Primarily useful on Erlang target (network protocols, binary parsing).

```gleam
// Construction
let greeting = <<"Hello":utf8>>
let packet = <<1:8, 256:16-big, 3.14:float>>
let flags = <<1:1, 0:1, 1:1>>

// Pattern matching
case data {
  <<version:8, length:16-big, rest:bits>> -> Ok(#(version, length, rest))
  _ -> Error("invalid")
}

// Options: size(n), unit(n), big, little, native,
//          signed, unsigned, float, utf8, utf16, utf32, bits/bytes
```

**JavaScript note:** Full bit array support (endianness, signed ints, 32/64-bit floats) was added progressively through v1.x. Not all options available before v1.4.

---

## 17. Concurrency Model (High Level)

Gleam on BEAM inherits Erlang's model:

- Lightweight processes (not OS threads)
- Message passing via mailboxes
- No shared mutable state
- "Let it crash" philosophy — supervisors restart failed processes
- All of this is accessed via `gleam_erlang` and `gleam_otp`

On JavaScript: no concurrency primitives — single-threaded event loop.

The type system makes message passing safer than raw Erlang: `Subject(MessageType)` ensures only correctly-typed messages can be sent to an actor.

---

## 18. Key Compiler Behaviors

- **Exhaustiveness checking:** All `case` expressions must cover all variants
- **Unused variable warning:** `_` prefix suppresses it (`_unused`)
- **Unused import warning:** Remove unused imports
- **Redundant pattern warning:** Unreachable branches flagged
- **Redundant `let assert` warning (v1.10+):** When pattern is provably irrefutable
- **Detached doc comment warning (v1.14+):** `///` not attached to a definition
- **Redundant module warning (v1.14+):** Module with no public definitions
- Type inference is complete — annotations optional except at module boundaries (good practice to annotate `pub` functions)
- No implicit coercions anywhere

---

## Sources

- https://gleam.run/news/the-happy-holidays-2025-release/ (v1.14 changelog)
- https://gleam.run/documentation/externals/ (FFI guide)
- https://gleam.run/frequently-asked-questions/ (design decisions)
- Context7: /gleam-lang/gleam (646 snippets, High reputation)
- Context7: /gleam-lang/otp (37 snippets, High reputation)
- Context7: /websites/hexdocs_pm_gleam_stdlib (364 snippets, High reputation)
- Gleam changelogs v1.1–v1.14 (via Context7 GitHub source)
