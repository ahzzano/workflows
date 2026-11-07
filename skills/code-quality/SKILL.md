---
name: code-quality
description: Language agnostic code quality standards for readable code. Always use when writing large parts of the codebase or reviewing architecture. 
metadata:
    origin: Will
---

# Coding Standards & Best Practices
Baseline coding conventions applicable across projects

This is a shared playbook. Not a source of truth

If there skills that are more language specific, you may use this as well as that skill

## Code Quality Principles

### 1. Readability First
- Code is read more than written
- Clear variable and function names
- Self-documenting code preferred over comments
- Consistent formatting

### 2. KISS (Keep It Simple, Stupid)
- Simplest solution that works
- Avoid over-engineering
- No premature optimization
- Easy to understand > clever code

### 3. DRY (Don't Repeat Yourself)
- Extract common logic into functions when the logic appears for 3 or more times and changes for the same reason
- Duplication is cheaper than the wrong abstraction; two similar blocks can stay
- Don't create shared utilities or components for a single caller

### 4. YAGNI (You Aren't Gonna Need It)
- Don't build features before they're needed
- Avoid speculative generality
- Add complexity only when required
- Start simple, refactor when needed

## Naming Conventions
### Verb-noun function names 
```py
# PASS: verb-noun pattern 
def do_x():
    ...

def calculate_mass():
    ...
# FAIL: unclear or noun only 
def mass():
    ...
```

Exception: accessors and properties are named after the value they return (`balance`, `name()`), not a verb.

## General Code Smells

### Magic Numbers 
```py
# FAIL: unexplained numbers
if retry_count > 3:
    ...

# PASS: explained numbers 
MAX_RETRIES = 3
if retry_count > MAX_RETRIES:
    ...
```

### Long functions
```py
# FAIL
def long_function():
    # 1k lines

# PASS: 
def short_function():
    f1()
    f2()
    f3()
    ...
```

### Over-exposed state
Keep fields private when they protect an invariant (a value that must stay valid,
or must change together with another field). Plain data with no invariant may stay public.
Do not add getters/setters that only pass a value through.
Follow the language's accessor conventions (e.g. see `rust-patterns` for Rust).

```py
# FAIL: callers can break the invariant (balance must match transactions)
class Account:
    def __init__(self):
        self.balance = 0
        self.transactions = []

# PASS: invariant enforced in one place
class Account:
    def __init__(self):
        self._balance = 0
        self._transactions = []

    def deposit(self, amount):
        ...

    @property
    def balance(self):
        return self._balance
```
