---
name: tdd
description: Follow Test Driven Development standards
---

# TDD
Test-driven development for better development

# Best Practices
## Behavior, Not Implementation
## Always base tests on the reference/document 
- Create tests first based on the documentation

## AAA Pattern
```
[Fact]
public void BasketTotal_ReturnTotalPrice_WhenBasketHasItems()
{
    // arrange
    var basket = GetBasket();
    basket.Add(new BasketItem("Item 1", 1.00));
    basket.Add(new BasketItem("Item 2", 2.00));

    // act
    var total = basket.Total();

    // assert
    Assert.AreEqual(2.99,  total);
}
```

## Use setup and cleaner functions 
```rust
#[cfg(test)]
mod tests {
    fn setup_processor() -> Processor {
        Processor::new()
    }

    #[test]
    fn test_processor() {
        ...
    }
}
```
