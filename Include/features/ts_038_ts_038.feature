@TS-038 @regression @api @demo-mode
Feature: TS-038 Demo mode - access grants stored as in-memory user_email/role tuples

  Background:
    Given the portal API is running at "http://localhost:8000"
    And all projects have been reset via "clear state"

  Scenario: Added member is stored as {user_email, role} tuple visible in GET /api/projects/{id}
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "tuple-test",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "alice@x.com",
        "role": "Admin"
      }
      """
    Then the response status should be 200
    When I send a GET request to "/api/projects/{projectId}"
    Then the response status should be 200
    And the "members" array contains an object where "user_email" equals "alice@x.com"

  Scenario: Multiple members are stored as separate tuples in the members array
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "multi-tuple",
        "project_type": "Batch Job",
        "language": "Python"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "bob@y.com",
        "role": "Developer"
      }
      """
    Then the response status should be 200
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "carol@z.com",
        "role": "Read-Only"
      }
      """
    Then the response status should be 200
    When I send a GET request to "/api/projects/{projectId}"
    Then the response status should be 200
    And the response JSON field "members" is an array with exactly 2 items
    And the "members" array contains an object where "user_email" equals "bob@y.com"
    And the "members" array contains an object where "user_email" equals "carol@z.com"

  Scenario: Member record in the POST response contains both user_email and role fields
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "tuple-fields",
        "project_type": "Library",
        "language": "TypeScript"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "dave@acme.com",
        "role": "Developer"
      }
      """
    Then the response status should be 200
    And the response body should have a top-level key "status"
    And the response body should have a top-level key "member"
    And the response JSON field "member.user_email" should equal "dave@acme.com"
    And the response JSON field "member.role" should equal "Developer"

  Scenario: POST /api/_reset also clears all in-memory member tuples
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "reset-members",
        "project_type": "Frontend App",
        "language": "React"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "eve@corp.com",
        "role": "Admin"
      }
      """
    Then the response status should be 200
    When I send a POST request to "/api/_reset" with no body
    Then the response status should be 200
    When I send a GET request to "/api/projects/{projectId}"
    Then the response status should be 404


# ─────────────────────────────────────────────────────────────────────────────
# FR-L12  Remove member happy path
#
# ⚠  PLANTED BUG #3 — remove_member() in app.py is a no-op.
#    DELETE returns HTTP 200 but does NOT mutate the members array.
#    Scenarios verifying the member is absent after DELETE WILL FAIL.
# ─────────────────────────────────────────────────────────────────────────────