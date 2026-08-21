@TS-013 @regression @api @ui @demo-mode
Feature: TS-013 Add team members to a project with role assignment

  Background:
    Given the portal API is running at "http://localhost:8000"
    And all projects have been reset via "clear state"

  Scenario: POST /api/projects/{id}/members adds a member with Admin role and returns 200
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "member-test-admin",
        "project_type": "Microservice",
        "language": "Python/Flask"
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
    And the response JSON field "status" should equal "ok"
    And the response JSON field "member.user_email" should equal "alice@x.com"
    And the response JSON field "member.role" should equal "Admin"

  Scenario: POST /api/projects/{id}/members adds a member with Developer role
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "member-test-dev",
        "project_type": "Batch Job",
        "language": "Java"
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

  Scenario: POST /api/projects/{id}/members adds a member with Read-Only role
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "member-test-ro",
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

  Scenario: Added member appears in subsequent GET /api/projects/{id} response
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "member-visible",
        "project_type": "Frontend App",
        "language": "Vue"
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
    When I send a GET request to "/api/projects/{projectId}"
    Then the response status should be 200
    And the "members" array contains an object where "user_email" equals "dave@acme.com"

  Scenario: POST /api/projects/{id}/members on a non-existent project returns 404
    When I send a POST request to "/api/projects/00000000-0000-4000-8000-000000000000/members" with body:
      """
      {
        "user_email": "nobody@x.com",
        "role": "Developer"
      }
      """
    Then the response status should be 404
    And the response JSON field "detail" should equal "Project not found"

  Scenario: POST /api/projects/{id}/members rejects an email without the @ character (FR-L09)
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "email-val-proj",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "not-an-email",
        "role": "Admin"
      }
      """
    Then the response status should be 400
    And the response JSON field "detail" should equal "Valid email is required"

  Scenario: POST /api/projects/{id}/members rejects a duplicate email with 409 (FR-L10, AC-10)
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "dup-member-proj",
        "project_type": "Data Pipeline",
        "language": "Python"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "eve@corp.com",
        "role": "Developer"
      }
      """
    Then the response status should be 200
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "eve@corp.com",
        "role": "Read-Only"
      }
      """
    Then the response status should be 409
    And the response JSON field "detail" should equal "Member already in project"

  Scenario: UI Add Member form shows success banner and new member appears in member list
    Given I am on the landing page
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "ui-member-proj",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 201
    When I click the element with data-testid "card-add"
    And I select "ui-member-proj" from the element with data-testid "select-project"
    And I type "frank@test.com" into the element with data-testid "input-member-email"
    And I select "Admin" from the element with data-testid "input-member-role"
    And I click the element with data-testid "btn-add-member"
    Then the element with data-testid "member-success" should be visible
    And the element with data-testid "member-success" should contain the text "frank@test.com"
    And the element with data-testid "member-success" should contain the text "Admin"


# ─────────────────────────────────────────────────────────────────────────────
# TS-014  Validate role assignment — accept only Admin, Developer, Read-Only
#
# ⚠  PLANTED BUG #2 — role allowlist check is commented out in add_member().
#    POST with role="GodMode" returns HTTP 200 instead of HTTP 400.
#    Scenarios asserting 400 for invalid roles WILL FAIL until the bug is fixed.
# ─────────────────────────────────────────────────────────────────────────────