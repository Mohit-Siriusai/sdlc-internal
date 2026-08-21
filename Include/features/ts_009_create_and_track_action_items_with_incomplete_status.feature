@TS-009 @regression @api @demo-mode
Feature: TS-009 Project creation happy path - valid project name accepted

  Background:
    Given the portal API is running at "http://localhost:8000"
    And all projects have been reset via "clear state"

  Scenario: POST /api/projects with valid input returns 201 and a full project record (AC-02)
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "demo-1",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 201
    And the response Content-Type should contain "application/json"
    And the response JSON field "project_name" should equal "demo-1"
    And the response JSON field "project_type" should equal "Microservice"
    And the response JSON field "language" should equal "Java/Spring Boot"
    And the response JSON field "id" is a non-empty string
    And the response JSON field "members" is an empty array
    And the response JSON field "created_at" is a non-empty string

  Scenario: Project name containing only letters, digits, and hyphens is accepted
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "proj-42",
        "project_type": "Batch Job",
        "language": "Python"
      }
      """
    Then the response status should be 201
    And the response JSON field "project_name" should equal "proj-42"

  Scenario: Project name containing only uppercase letters is accepted
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "MYPROJECT",
        "project_type": "Library",
        "language": "Java"
      }
      """
    Then the response status should be 201
    And the response JSON field "project_name" should equal "MYPROJECT"

  Scenario: Single-character project name is accepted
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "A",
        "project_type": "Frontend App",
        "language": "React"
      }
      """
    Then the response status should be 201

  Scenario: Newly created project appears in GET /api/projects list (AC-02)
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "visible-project",
        "project_type": "Data Pipeline",
        "language": "Scala"
      }
      """
    Then the response status should be 201
    When I send a GET request to "/api/projects"
    Then the response status should be 200
    And the response JSON field "projects" is an array with exactly 1 items
    And the "projects" array contains an object where "project_name" equals "visible-project"

  Scenario: Newly created project is retrievable via GET /api/projects/{id}
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "retrievable-proj",
        "project_type": "Microservice",
        "language": "Python/Flask"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a GET request to "/api/projects/{projectId}"
    Then the response status should be 200
    And the response JSON field "project_name" should equal "retrievable-proj"
    And the response JSON field "id" should equal the stored value "projectId"

  Scenario: UI wizard submits project and shows success banner with project name and ID
    Given I am on the wizard view
    When I select "Batch Job" from the element with data-testid "input-type"
    And I select "Shell" from the element with data-testid "input-language"
    And I type "my-batch-job" into the element with data-testid "input-name"
    And I click the element with data-testid "btn-submit"
    Then the element with data-testid "wizard-success" should be visible
    And the element with data-testid "wizard-success" should contain the text "my-batch-job"
    And the element with data-testid "wizard-success" should contain the text "created successfully"


# ─────────────────────────────────────────────────────────────────────────────
# TS-010  Reject project name with invalid characters
# ─────────────────────────────────────────────────────────────────────────────