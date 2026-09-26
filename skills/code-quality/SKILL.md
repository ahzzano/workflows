---
name: code-quality
description: Language agnostic code quality standards for readable code
metadata:
    origin: Will
---

# Coding Standards & Best Practices
Baeline coding conventions applicable across projects

This is a shared playbook. Not a source of truth

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
- Extract common logic into functions
- Create reusable components
- Share utilities across modules
- Avoid copy-paste programming

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

def x(self):
    return self.x

def mass():
    ...
```

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
