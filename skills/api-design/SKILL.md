---
name: api-design
description: REST/HTTP API design guidelines covering methods, status codes, URL naming, request/response shapes, error format, and versioning. Use when designing, implementing, or reviewing backend endpoints or route handlers.
---

This skill is a playbook/set of principles to design better APIs. If you are designing backend APIs or auditing backend implementations, use this skill

# Methods
| Method | description |
|--------|-------------|
| GET    | Used to retrieve a representation of a resource | 
|  POST | Used to create new resources, and trigger actions | 
| DELETE | Used to delete existing resources | 
|  PUT | Used to update existing resources. PUT replaces the entire resource | 
| PATCH | Used to update existing resources. PATCH applies partial modifications | 

# Status Code References
## Success
200 OK                    — GET, PUT, PATCH (with response body)
201 Created               — POST (include Location header)
204 No Content            — DELETE, PUT (no response body)

## Client Errors
400 Bad Request           — Malformed request, unparseable JSON
401 Unauthorized          — Missing or invalid authentication
403 Forbidden             — Authenticated but not authorized
404 Not Found             — Resource doesn't exist
409 Conflict              — Duplicate entry, state conflict
422 Unprocessable Entity  — Semantically invalid (valid JSON, bad data)
429 Too Many Requests     — Rate limit exceeded

## Server Errors
500 Internal Server Error — Unexpected failure (never expose details)
502 Bad Gateway           — Upstream service failed
503 Service Unavailable   — Temporary overload, include Retry-After

# Good API Designs
## Hierarchical Design
```
# Resources are nouns
GET /api/projects/
POST /api/projects/

# Sub-resources for relationships
GET /api/projects/{projectId}/evaluations
GET /api/users/{userId}/profile

# Actions that don't map to CRUD (use verbs sparingly)
POST   /api/orders/{orderId}/cancel
POST   /api/auth/login
```

## Naming Guidelines
### Routes should speak for themselves
```
BAD:
GET /api/get/project                          # Don't put actions that are mappable to CRUD in the URL.
GET /api/getById/project?id=123
GET /api/evaluations?projectId=123            # Evaluation is a property inside Project. 
GET /api/getProjectEvaluations/123            

GOOD:
GET /api/projects                             # If there are multiple resources, always use plural nouns
GET /api/users/123/profile                    # If there is a one-to-one mapping between resources (i.e. a user can only have one profile), the noun should be in the singular
GET /api/projects/{projectId}
GET /api/projects/{projectId}/team-leaders    # Use kebab case for multi word resources, actions, etc.
GET /api/projects/{projectId}/evaluations     # Use hierarchical design for nested resources
```

## Parameters
### Always use lower camel case for fields and query parameters
```
BAD:

GET /api/projects?sort=project_name
POST /api/projects
{
  "project_name": "Meta",
  "project_age": 12
}

GOOD:

GET /api/projects?sort=projectName
POST /api/projects
{
  "projectName": "Meta",
  "projectAge": 12
}
```

## API Responses
### Never return primitives or arrays as responses
```
BAD:

GET /api/projects
Response:
[
  { ...project1... },
  { ...project2... }
]

GET /api/projects/123/active
Response:
true

GOOD:

GET /api/projects
Response:
{
  "data": [
    { ...project1... },
    { ...project2... }
  ],
  "paging": {
    "page": 0,
    "size": 25,
    "totalElements": 142,
    "totalPages": 6
  }
}

GET /api/projects/123/active
Response:
{
    "isActive": true
}
```

### Never use abbreviations for property names
```
BAD:
{
  "pId": "922414a2-5f52-442d-9729-ad456ae30652",
}

GOOD:
{
  "projectId": "922414a2-5f52-442d-9729-ad456ae30652",
}
```

### Error Responses 
When an error occurs, maintain a consistent error format
```
HTTP 422 Unprocessable Entity
{
  "status": "UNPROCESSABLE_ENTITY",
  "code": 422,
  "timestamp": "2025-04-20T11:23:15.148431Z",
  "errors": [
    {
      "type": "VALIDATION_ERROR",
      "message": "Must not be empty",
      "field": "key"
    }
  ]
}
```

## API Versioning 
When an API change is not backwards compatible, release the changes as a new version 

```
Deprecated:
GET /api/projects

New:
GET /api/v2/projects
```

If the semantics of the API changes, introduce a new endpoint for that instead
