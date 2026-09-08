@TS-016 @regression @api @validation @demo-mode
Feature: TS-016 Server-side validation - language must be compatible with project type

  Background:
    Given the portal API is running at "http://localhost:8000"

  Scenario: POST /api/projects with React language for Microservice type returns 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "cross-type-1",
        "project_type": "Microservice",
        "language": "React"
      }
      """
    Then the response status should be 400
    And the response body should contain "is not valid for project type"
    And the response body should contain "Microservice"

  Scenario: POST /api/projects with Shell language for Frontend App type returns 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "cross-type-2",
        "project_type": "Frontend App",
        "language": "Shell"
      }
      """
    Then the response status should be 400
    And the response body should contain "is not valid for project type"

  Scenario: POST /api/projects with Scala language for Library type returns 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "cross-type-3",
        "project_type": "Library",
        "language": "Scala"
      }
      """
    Then the response status should be 400
    And the response body should contain "is not valid for project type"

  Scenario: POST /api/projects with React language for Batch Job type returns 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "cross-type-4",
        "project_type": "Batch Job",
        "language": "React"
      }
      """
    Then the response status should be 400
    And the response body should contain "is not valid for project type"

  Scenario: POST /api/projects with Python/Flask language for Data Pipeline type returns 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "cross-type-5",
        "project_type": "Data Pipeline",
        "language": "Python/Flask"
      }
      """
    Then the response status should be 400
    And the response body should contain "is not valid for project type"

  Scenario: POST /api/projects with TypeScript language for Batch Job type returns 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "cross-type-6",
        "project_type": "Batch Job",
        "language": "TypeScript"
      }
      """
    Then the response status should be 400
    And the response body should contain "is not valid for project type"

  Scenario: POST /api/projects with an unrecognised project type returns 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "unknown-type-proj",
        "project_type": "ChaosMonkey",
        "language": "Python"
      }
      """
    Then the response status should be 400
    And the response body should contain "Unknown project type"

  Scenario: POST /api/projects with Java/Spring Boot language for Batch Job type returns 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "cross-type-7",
        "project_type": "Batch Job",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 400
    And the response body should contain "is not valid for project type"


# ─────────────────────────────────────────────────────────────────────────────
# TS-032  Demo mode — project creation uses in-memory store with server UUID
# ─────────────────────────────────────────────────────────────────────────────