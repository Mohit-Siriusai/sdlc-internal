@TS-012 @regression @api @conflict @demo-mode @bug-1
Feature: TS-012 Reject duplicate project name

  Background:
    Given the portal API is running at "http://localhost:8000"
    And all projects have been reset via "clear state"

  Scenario: Second POST /api/projects with the same project_name returns 409 (AC-03)
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "demo-1",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 201
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "demo-1",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 409
    And the response JSON field "detail" should equal "Project name already exists"

  Scenario: Duplicate check is case-insensitive — lower-case variant of existing name returns 409
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "MyProject",
        "project_type": "Library",
        "language": "Java"
      }
      """
    Then the response status should be 201
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "myproject",
        "project_type": "Library",
        "language": "Python"
      }
      """
    Then the response status should be 409
    And the response body should contain "Project name already exists"

  Scenario: Duplicate project does not create a second record in GET /api/projects
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "unique-check",
        "project_type": "Batch Job",
        "language": "Shell"
      }
      """
    Then the response status should be 201
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "unique-check",
        "project_type": "Batch Job",
        "language": "Java"
      }
      """
    Then the response status should be 409
    When I send a GET request to "/api/projects"
    Then the response status should be 200
    And the response JSON field "projects" is an array with exactly 1 items

  Scenario: Two projects with distinct names are both accepted (positive boundary check)
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "project-alpha",
        "project_type": "Frontend App",
        "language": "React"
      }
      """
    Then the response status should be 201
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "project-beta",
        "project_type": "Frontend App",
        "language": "Angular"
      }
      """
    Then the response status should be 201
    When I send a GET request to "/api/projects"
    Then the response JSON field "projects" is an array with exactly 2 items


# ─────────────────────────────────────────────────────────────────────────────
# TS-013  Add optional team members with role assignment
# ─────────────────────────────────────────────────────────────────────────────