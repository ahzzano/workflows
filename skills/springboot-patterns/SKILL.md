---
name: springboot-patterns
description: Guidelines for writing good code for the Java springboot framework. Use when writing, auditing, or reviewing Java code for Springboot projects
---

Springboot is a framework used to create backend applications with Java. Use this skill when auditing, writing, reviewing, or editing Java projects that use Spring or Springboot.

# Use Spring Boot Starters 
Use starter dependencies over adding the individual dependencies one by one. This avoids version mismatches and we can get most of the dependencies we need much more quickly.

If you are starting a new project, this can easily be done using Spring Initialzr. 

# Vertical Slicing
Group services, controllers, and repositories by business domain rather than by layer.
```
BAD:
controllers/
- UserController.java
- OrderController.java

services/
- UserService.java 
- OrderService.java 

repositories 
- UserRepository.java 
- OrderRepository.java

GOOD:
user/
- UserController.java
- UserRepository.java 
- UserService.java 

order/
- OrderService.java 
- OrderRepository.java 
- OrderController.java
```
Exception: If the existing codebase already uses horizontal slicing instead of vertical slicing, ignore this rule. You can't adjust legacy code to fit this architecture despite it's benefits.

# Use Lombok 
Lombok is a Java library used to reduce boilerplate code. This will make you write less code for Getters and Setters.

# Use Slf4j Logging 
Logging is very important as thats the only way to find out the root cause in production. Avoid using System.out.print() and use slf4j when logging.

# Always Use Optional 
Finding why a NullPointerException occurs can get really frustrating. To ensure that debugging becomes easier, return Optional from methods that may have no result. Use `Optional.ofNullable`, since `Optional.of` throws a NullPointerException on null.
```java

var nullableObject = someFunctionThatCanReturnNull();

return Optional.ofNullable(nullableObject);
```
Don't use Optional for fields, method parameters, or collections (return an empty collection instead).

# Code Structure 
For a more detailed guide, refer to ![directory-structure.md](example/directory-structure.md) for more details
## Controllers 
Controllers are dedicated to routing. As such, they are stateless and a singleton. Requests should be handed over to the service layer and processed by the service layer. Business logic should not be in the controllers.
## Services 
Services is where the complete business logic goes. Logic such as validation, orchestration, etc. Services also communicate with the repository to store data and receive results. This must also be a singleton.

Services own transaction boundaries: put `@Transactional` on service methods (`readOnly = true` for reads), not on controllers or repositories. Cross-cutting concerns such as caching should be applied declaratively (e.g. `@Cacheable`) rather than hand-written inside the business logic.
## Repository 
Where functions related to database and persistence lives.

# Be Simple! 
Always write readable, understandable, and simple code.