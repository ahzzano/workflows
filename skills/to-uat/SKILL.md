---
name: to-uat
description: Turn the current conversation, PRD, spec, or plan into a set of User Acceptance requirements that will guide development
disable-model-invocation: true
---

Turn the current conversation into a series of UAT Tests that will be verified at a later date. 

This is not a system test. A system test is a test that verifies the if the software works according to technical specifications. A UAT is a test that verifies if the software actually solves the business problem that the user is facing.

# Process 
1. Analyze the current spec or requirements in the repo. The spec should contain user stories. These user stories will be the basis when creating UAT requirements.
2. Identify real-world business scenarios that can happen based on the user stories. Make sure that each path is handled correctly. Include ALL paths. Not just the happy path. Users are not perfect consumers of the product and will make mistakes when using it. It is important that the software can help the user whenever they are making a mistake. 
3. Create UAT test cases. Each test must be designed with clear steps and expected results to validate the business scenario 
4. Prepare test data. Keep the test data as realistic as possible so that the tests mirror the real-world business scenarios as close as possible.
5. Present your UAT requirements to the user 

  Check-in with the user to see if they approve of the test cases. Ask the user if
  - There are additional test cases they want covered
  - Are there tests that are redundant or impossible to trigger

6. Publish the UAT to the project issue tracker. If no such tracker is configured, output it to `UAT.md`

# Output Format
```md
# User Acceptance Testing
## Test Case #1 - User Does X
Brief description of the test case.

### User
Who the user is

### Pre-Conditions (GIVEN):
The list of assumptions we have about the user

### Steps
List of steps for the user to accomplish
1. Add X to Y
2. Proceed to B

### Expected Results
What should be the expected behavior of the test.
- [] Expected Result 1
- [] Expected Result 2
```

Example 

```md
## Test Case #1 - Buying a figurine without an account
Benjamin is a user who wants to buy the latest Talia Yang figurine from the online shop.

### User
Benjamin (Guest checkout)

### Pre-Conditions (GIVEN):
- The user has no account
- The items he wants to buy are currently in stock

### Steps
List of steps for the user to accomplish
1. Go to the catalog of the website
2. Go to the listing of the Talia Yang figurine 
3. Add the item to his cart
4. Proceed to the checkout 
5. Pay for the item using Credit Card/Debit Card/Apple Pay/etc.
6. Confirm the purchase

### Expected Results
- [] Benjamin should receive a "You have successfully completed the purchase" message
- [] Benjamin should receive a receipt via his email
```