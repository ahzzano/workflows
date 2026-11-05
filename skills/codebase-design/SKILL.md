---
name: codebase-design
description: Designing deep modules Use when the user wants to design or improve a module's interface
---

# Codebase Design
Design deep modules. A deep module is one that hides deep complex behavior behind a small interface. In contrast, a shallow module has a large interface but a very thin implementation layer.

Use this language and these principles when code is being designed or restructured.

When designing an interface, ask:
- Can I reduce the number of methods?
- Can I simplify the parameters?
- Can I hide more complexity inside?

# Design for Testability 
1. Accept dependencies, don't create them.
```js
// Testable
function processOrder(order, paymentGateway) {}

// Hard to test
function processOrder(order) {
  const gateway = new StripeGateway();
}
```

2. Return results, don't produce side effects.
```ts
// Testable
function calculateDiscount(cart): Discount {}

// Hard to test
function applyDiscount(cart): void {
  cart.total -= discount;
}
```

3. Fewer methods = fewer tests. 