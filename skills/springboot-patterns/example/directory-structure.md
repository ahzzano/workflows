# Controllers 
Controllers are dedicated to routing. As such, they are stateless and a singleton. Requests should be handed over to the service layer and processed by the service layer. Business logic should not be in the controllers.

# Services 
Services is where the complete business logic goes. Logic such as validation, caching, etc. Services also communicate with the repository to store data and receive results. This must also be a singleton

# Example
Sample Structure (using Vertical Slicing)
```
user/
- domain/
    - User.java
    - UserWithoutPassword.java
- responses/                
    - UserResponse.java
- requests/
    -  UserRequest.java
- UserController.java 
- UserService.java 
- UserRepository.java 
```

Sample Code:
```java 
// UserController.java 

@RestController
class UserController {
    private final UserService service;

    UserController(UserService service) {
        this.service = service;
    }


    @GetMapping("/users")
    List<User> all() {
        return service.getAllEmployees();
    }

    @GetMapping("/users/{id}")
    User getUser(@RequestBody UserRequest request) {
        return service.getUserProfile(request.id);
    }
}

// UserService.java
class UserService {
    private final UserRepository repository;

    UserService(UserRepository repository) {
        this.repository = repository;
    }

    List<User> getAllEmployees() {
        return this.repository.findAll();
    }

    UserWithoutPassword getUserProfile(id) {
        return this.repository.findById(id)
    }
}
```