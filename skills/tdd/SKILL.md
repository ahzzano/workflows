---
name: tdd
description: Test-Driven development . Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor" , or wants integration tests
---

# Test-Driven development
Test-driven development for better development. Use when you want to use a Red-Green-Refactor loop for the project

# Loop
1. *Red* - Write failing tests first 
2. *Green* - Write only enough code so that the failing tests pass 

# Good Tests
A good test verifies behavior through public interfaces, not implementation details.

Here is one such example 

```typescript
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

# Anti-Patterns
Here are some patterns that you should avoid:
1. Tautological tests - Recomputing the expected value instead of using literals 
2. Testing for implementation - Tests that use private methods or verifying via external means (i.e. directly querying the database)
3. Horizontal Slicing - Writing all the tests first before implementation. Always follow a one test -> one feature loop

# Mocking
Mock at system boundaries only 
- External APIs (payment, email, etc.)
- Databases (sometimes - prefer test DB)
- Time/randomness
- File system (sometimes)

Rule of thumb: Mock all third-party services. Don't mock anything in your control

## Designing for Mockability
1. Use dependency injection 

   Pass external dependencies rather than directly creating them 
2. Prefer SDK-style interfaces over generic ones 

```ts
// GOOD: Each function is independently mockable
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// BAD: Mocking requires conditional logic inside the mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```


# Rules 
- Refactoring is not part of the loop. Refactoring will be done using `/code-review`
- Accomplish one slice at a time