---
name: rust-patterns
description: A guide of best practices and principles when writing, reviewing, and auditing Rust code. Use this when editing and reviewing Rust code.
---

This is a set of principles and best practices that you can use to write Rust code.

# Conventions 
## Getters 
```rust
pub struct S {
    first: First,
    second: Second,
}
impl S {
    // Not get_first.
    pub fn first(&self) -> &First {
        &self.first
    }
    // Not get_first_mut, get_mut_first, or mut_first.
    pub fn first_mut(&mut self) -> &mut First {
        &mut self.first
    }
}
```

Only use "get" whenever the underlying value being accessed is obvious (i.e. `Cell::get()`)

# Type Safety 
## use newtype
Use new types when you have different interpretations of the same underlying type
```rust 
struct Miles(pub f64);
struct Kilometers(pub f64);

impl Miles {
    fn to_kilometers(self) -> Kilometers { /* ... */ }
}
impl Kilometers {
    fn to_miles(self) -> Miles { /* ... */ }
}
```
## Express boolean arguments by enums instead of bools 
```rust
// Bad: we don't know what the arguments are just by reading it
let w = Widget::new(true, false)

// Good: We immediately know what the arguments are just by looking at it
let w = Widget::new(Small, Round)
```

# Prefer borrows over deep copies
Use `.clone()` when you genuinely need a deep copy of an object.

Avoid using `.clone()` as a substitute for borrowing. Design code that works naturally with Rust’s ownership and borrowing rules. However, if the borrowing relationships become excessively complex, .clone() can be a pragmatic choice.

Consider the performance needs of the code while choosing between cloning and borrowing.

Default to borrowing (`&T` or `&mut T`). Only when you need an owned value, choose between cloning and copying:

| Prefer Cloning when ... | Prefer Copying when... | 
|-|-|
| - When using `Arc` or `Rc` objects or the object is shared across multiple threads | - The type implements Copy (u32, bool, f32, small structs).|
| - You need to change the object AND preserve the original object (immutable snapshots). | - The cost of moving the value is negligible.|
| - When the underlying API expects Owned Data. | - The struct is at most 2-3 words of memory or around 24 - 64 bytes|
| - Avoid massive refactoring of non-performance critical code | | 


Enums should derive copy when 
- If your enum acts like tags and atoms.
- The enum payloads are all Copy.

```rust
// Example:
#[derive(Debug, Copy, Clone)]
enum Direction {
  North,
  South,
  East,
  West,
}
```

## Passing ownership
Pass ownership when:
- When you truly need a new copy such as but not limited to 
    - Crate API Design requires owned data.
    - Have overloaded std::ops but still need ownership to the old data:
    - Need to do comparison snapshots or due to API you need multiple owned instances of the data.
- Using `Arc` or `Rc`
- You have structs that are too big to derive Copy but still cheap to move (no heap data to clone).

## Ownership Design
- Prefer API designs that take reference (fn process(values: &[T])), instead of ownership (fn process(values: Vec<T>)).
- If you only need read access to elements, prefer `.iter` or `slices`.
- If you need to mutate data, take `&mut MyStruct` instead of taking ownership and returning it.
- If the data is shared across threads, wrap it in `Arc<Mutex<T>>` (or `RwLock`), or send it over a channel. A plain `&mut` cannot cross thread boundaries (except with `std::thread::scope`).

# Stack vs Heap 
- Keep small types (impl Copy, usize, bool, etc.) on the Stack
- Avoid passing huge types (> 512 bytes) by value or passing ownership. Pass them by reference instead
- Heap allocate recursive data structures:
```rust 
enum OctreeNode<T> {
    Node(T),
    Children(Box<[OctreeNode<T>; 8]>),
}
```
- Return small types by value, types that implement Copy or a cheaply Cloned are efficient to return by value (e.g. struct Vector2 {x: f32, y: f32}).

# Call functions using their module names instead of direct Imports
```rust 
// BAD
use std::mem::transmute;

let x = transmute(y);

// GOOD: 
use std::mem;

let x = mem::transmute(y);
```

Exceptions:
- When the module name itself is prone to collisions. For example, when the module name is a C++ namespace name, and multiple crates define the same submodules.
- When importing functions with sufficiently disambiguated names, e.g., functions from C++ (where it is typical to call top-level (free) functions directly).

# Error Handling 
## Option<T>
```rust 
// This code will only fail because of an integer overflow. This is obvious to the caller
fn checked_add(a: u32, b: u32) -> Option<u32> { ... }
```
## Result<T, E>
```rust
// Good: The caller needs to know *why* it failed (NotFound vs PermissionDenied).
fn open_file(path: &Path) -> Result<File, io::Error> { ... }
```

## panic!()
Always prefer `Result<T, E>` over panic unless a specific invariant is violated 
```rust
// Good: Panics if the invariant (index must be in bounds) is violated.
// This indicates a bug in the caller's logic.
impl<T> MyVec<T> {
    pub fn remove(&mut self, index: usize) -> T {
        if index >= self.len() {
            panic!("index out of bounds");
        }
        // ...
    }
}
```

# Implementation 
## Pattern Matching over check-then-unwrap
```rust
// Bad: Correctness of `unwrap` relies on a runtime check that `option` is `Some`.
if option.is_some() {
    use_value(option.unwrap());
}

// Good
if let Some(value) = option {
    use_value(value);
}
```

## Avoid expect() and unwrap()
Instead: use any of the following patterns: 
```rust
// Use when you can have a predefined early return value that doesn't need to know the `Err` value
let Ok(json) = serde_json::from_str(&input) else {
    return Err(MyError::InvalidJson);
};

// Use when the error needs a recovery 
let json = match serde_json::from_str(&input) {
    Ok(json) => json,
    Err(err) => recover_from(&input, err)?,
};

```
Only use the aforementioned functions when:
- In tests, assertions or test helper functions.
- When failure is impossible.
- When the smarter options can't handle the specific case.
