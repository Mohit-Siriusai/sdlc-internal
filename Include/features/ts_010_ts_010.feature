@TS-010 @regression @api @validation @demo-mode
Feature: TS-010 Reject project name with invalid characters

  Background:
    Given the portal API is running at "http://localhost:8000"

  Scenario Outline: POST /api/projects rejects project names containing invalid characters with HTTP 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "<invalid_name>",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 400
    And the response JSON field "detail" should equal "Project name must contain only ASCII letters, digits, and hyphens"

    Examples:
      | invalid_name |
      | bad name!    |
      | my_project   |
      | my.project   |
      | project@123  |
      | hello world  |
      | proj#1       |
      | proj/sub     |
      | proj+extra   |
      | name$here    |
      | test:proj    |

  Scenario: Error response for invalid characters uses correct JSON detail shape
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "bad_name",
        "project_type": "Library",
        "language": "Python"
      }
      """
    Then the response status should be 400
    And the response body should have a top-level key "detail"
    And the response JSON field "detail" should equal "Project name must contain only ASCII letters, digits, and hyphens"

  Scenario: UI wizard shows wizard-error banner when project name contains invalid characters
    Given I am on the wizard view
    When I select "Microservice" from the element with data-testid "input-type"
    And I select "Java/Spring Boot" from the element with data-testid "input-language"
    And I type "bad name!" into the element with data-testid "input-name"
    And I click the element with data-testid "btn-submit"
    Then the element with data-testid "wizard-error" should be visible
    And the element with data-testid "wizard-error" should contain the text "Project name must contain only ASCII letters, digits, and hyphens"


# ─────────────────────────────────────────────────────────────────────────────
# TS-011  Reject empty or whitespace-only project name
# ─────────────────────────────────────────────────────────────────────────────