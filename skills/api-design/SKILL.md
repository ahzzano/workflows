---
name: api-design
description: API design guidelines and principles for auditing and writing backend designs
---

This skill is a playbook/set of principles to design better APIs. If you are designing backend APIs or auditing backend implementations, use this skill

# Methods
| Method | description |
|--------|-------------|
| GET    | Used to retrieve a representation of a resource | 
|  POST | Used to create new resources | 
| DELETE | Used to delete existing resources | 
|  PUT | Used to update existing resources. PUT replaces the entire resource | 
| PATCH | Used to update existing resources. PATCH applies partial modifications | 


# Good API Designs
## Consistency 
Similar end points should always follow the same pattern 
```
GET /api/users/{userId}/name
GET /api/projects/{projectId}/name
```

## Hierarchical Design
Nested resources should use a hierarchical url structure to reflect this relationship
```
BAD:
GET /api/evaluations?projectId=123
GET /api/getProjectEvaluations/123

GOOD:
GET /api/projects/123/evaluations
```

## Naming Guidelines
### Routes should speak for themselves
```
BAD:
GET /api/get/project
GET /api/getById/project?id=123

GOOD:
GET /api/projects
GET /api/projects/{projectId}
```

### Always use plural nouns when there are multiple resources
```
BAD:
GET /api/project

GOOD:
GET /api/projects
GET /api/projects/{projectId}
```

### Use action endpoints only for operations that aren't CRUD
Standard create/read/update/delete uses the HTTP method on the resource.
Use a verb sub-resource only when the operation is not a field update
(it triggers a workflow or side effect).
```
GOOD (CRUD):
POST  /api/projects
PATCH /api/projects/123

GOOD (action):
POST /api/projects/123/archive
POST /api/projects/123/members/456/assign

BAD:
PUT /api/projects/123/user/456/assign   # PUT means "replace", not "do something"
```

### Always use Kebab Case for url paths 
```
GOOD:
/api/projects/{projectId}/reset-members
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
### Always use conventional pagination syntax 
Request Parameters
- page: The numeric page number. 0 is the first page. If not provided, the default is 0.
- size: The number of items per page. If not specified, the default is 100.
```
GET /api/projects?page=2&size=15
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
HTTP 400 Bad Request
{
  "status": "BAD_REQUEST",
  "code": 400,
  "timestamp": "2025-04-20T11:23:15.148431Z",
  "errors": [
    {
      "type": "VALIDATION_ERROR",
      "message": "Provided value does not match pattern",
      "field": "key"
    },
    {
      "type": "VALIDATION_ERROR",
      "message": "Field is missing",
      "field": "test"
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
