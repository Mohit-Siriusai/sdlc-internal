@TS-011 @regression @api @validation @demo-mode
Feature: TS-011 Reject empty or whitespace-only project name

  Background:
    Given the portal API is running at "http://localhost:8000"

  Scenario: POST /api/projects with empty project_name returns 400 with "Project name is required"
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 400
    And the response JSON field "detail" should equal "Project name is required"

  Scenario: POST /api/projects with whitespace-only project_name returns 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "   ",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 400
    And the response JSON field "detail" should equal "Project name is required"

  Scenario: POST /api/projects with tab-only project_name returns 400
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "\t",
        "project_type": "Batch Job",
        "language": "Java"
      }
      """
    Then the response status should be 400
    And the response JSON field "detail" should equal "Project name is required"

  Scenario: UI wizard shows error banner when project name field is left blank on submit
    Given I am on the wizard view
    When I select "Library" from the element with data-testid "input-type"
    And I select "Python" from the element with data-testid "input-language"
    And I type " " into the element with data-testid "input-name"
    And I click the element with data-testid "btn-submit"
    Then the element with data-testid "wizard-error" should be visible
    And the element with data-testid "wizard-error" should contain the text "Project name is required"


# ─────────────────────────────────────────────────────────────────────────────
# TS-012  Reject duplicate project name
#
# ⚠  PLANTED BUG #1 — duplicate-name check is commented out in create_project().
#    The second POST returns HTTP 201 instead of HTTP 409.
#    All scenarios in this feature WILL FAIL until the bug is fixed.
# ─────────────────────────────────────────────────────────────────────────────