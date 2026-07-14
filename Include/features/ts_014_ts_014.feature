@TS-014 @regression @api @validation @demo-mode
Feature: TS-014 Validate role assignment - accept only Admin, Developer, Read-Only

  Background:
    Given the portal API is running at "http://localhost:8000"
    And all projects have been reset via "clear state"

  Scenario: POST /api/projects/{id}/members accepts valid role "Admin"
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "role-valid-1",
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
    And the response JSON field "member.role" should equal "Admin"

  Scenario: POST /api/projects/{id}/members accepts valid role "Developer"
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "role-valid-2",
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
    And the response JSON field "member.role" should equal "Developer"

  Scenario: POST /api/projects/{id}/members accepts valid role "Read-Only"
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "role-valid-3",
        "project_type": "Library",
        "language": "TypeScript"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "carol@z.com",
        "role": "Read-Only"
      }
      """
    Then the response status should be 200
    And the response JSON field "member.role" should equal "Read-Only"

  @bug-2
  Scenario Outline: POST /api/projects/{id}/members rejects invalid role values with HTTP 400 (AC-06)
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "role-invalid",
        "project_type": "Data Pipeline",
        "language": "Scala"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "test@x.com",
        "role": "<invalid_role>"
      }
      """
    Then the response status should be 400
    And the response body should contain "Invalid role"
    And the response body should contain "Admin, Developer, Read-Only"

    Examples:
      | invalid_role |
      | GodMode      |
      | admin        |
      | DEVELOPER    |
      | SuperAdmin   |
      | Owner        |
      | read-only    |
      | Write        |
      | viewer       |

  @bug-2
  Scenario: Error detail for invalid role matches exact format from add_member() in app.py
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "role-msg-test",
        "project_type": "Frontend App",
        "language": "React"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "dave@acme.com",
        "role": "GodMode"
      }
      """
    Then the response status should be 400
    And the response JSON field "detail" should equal "Invalid role 'GodMode'. Must be one of: Admin, Developer, Read-Only"

  Scenario: UI role dropdown offers exactly the three valid role options
    Given I am on the landing page
    When I click the element with data-testid "card-add"
    Then the element with data-testid "input-member-role" contains an option with text "Admin"
    And the element with data-testid "input-member-role" contains an option with text "Developer"
    And the element with data-testid "input-member-role" contains an option with text "Read-Only"
    And the element with data-testid "input-member-role" should NOT have an option with value "GodMode"
    And the element with data-testid "input-member-role" should NOT have an option with value "SuperAdmin"
    And the element with data-testid "input-member-role" should NOT have an option with value "Owner"


# ─────────────────────────────────────────────────────────────────────────────
# TS-016  Server-side validation — language must be compatible with project type
# ─────────────────────────────────────────────────────────────────────────────