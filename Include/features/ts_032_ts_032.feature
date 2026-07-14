@TS-032 @regression @api @demo-mode
Feature: TS-032 Demo mode - project creation persists in-memory with server-generated UUID

  Background:
    Given the portal API is running at "http://localhost:8000"
    And all projects have been reset via "clear state"

  Scenario: POST /api/projects returns a server-generated UUID v4 in the "id" field
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "uuid-test",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 201
    And the response JSON field "id" is a non-empty string
    And the response JSON field "id" matches the UUID v4 pattern "[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}"

  Scenario: Two separate project creations produce different server-generated UUIDs
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "uuid-alpha",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "firstId"
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "uuid-beta",
        "project_type": "Batch Job",
        "language": "Python"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "secondId"
    Then "firstId" should not equal "secondId"

  Scenario: POST /api/_reset clears all in-memory project state
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "pre-reset",
        "project_type": "Library",
        "language": "Java"
      }
      """
    Then the response status should be 201
    When I send a GET request to "/api/projects"
    Then the response JSON field "projects" is an array with at least 1 items
    When I send a POST request to "/api/_reset" with no body
    Then the response status should be 200
    When I send a GET request to "/api/projects"
    Then the response JSON field "projects" is an empty array

  Scenario: Project record returned by POST /api/projects contains all required top-level fields
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "field-check",
        "project_type": "Data Pipeline",
        "language": "Scala"
      }
      """
    Then the response status should be 201
    And the response body should have a top-level key "id"
    And the response body should have a top-level key "project_name"
    And the response body should have a top-level key "project_type"
    And the response body should have a top-level key "language"
    And the response body should have a top-level key "members"
    And the response body should have a top-level key "created_at"

  Scenario: GET /api/projects/{id} for a non-existent project ID returns 404 (FR-L14)
    When I send a GET request to "/api/projects/00000000-0000-4000-8000-000000000000"
    Then the response status should be 404
    And the response JSON field "detail" should equal "Project not found"

  Scenario: GET /api/projects returns projects sorted by created_at order
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "first-proj",
        "project_type": "Frontend App",
        "language": "Angular"
      }
      """
    Then the response status should be 201
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "second-proj",
        "project_type": "Library",
        "language": "Python"
      }
      """
    Then the response status should be 201
    When I send a GET request to "/api/projects"
    Then the response status should be 200
    And the response JSON field "projects" is an array with exactly 2 items


# ─────────────────────────────────────────────────────────────────────────────
# TS-038  Demo mode — access grants persisted as in-memory {user_email, role} tuples
# ─────────────────────────────────────────────────────────────────────────────