@TS-008 @regression @api @ui @demo-mode
Feature: TS-008 Language options filtered by project type - Data Pipeline

  Background:
    Given the portal API is running at "http://localhost:8000"

  Scenario: GET /api/languages for Data Pipeline returns exactly Python and Scala
    When I send a GET request to "/api/languages?project_type=Data%20Pipeline"
    Then the response status should be 200
    And the response JSON field "languages" is an array with exactly 2 items
    And the "languages" array contains "Python"
    And the "languages" array contains "Scala"

  Scenario: GET /api/languages for Data Pipeline does NOT include incompatible languages
    When I send a GET request to "/api/languages?project_type=Data%20Pipeline"
    Then the response status should be 200
    And the "languages" array should NOT contain "React"
    And the "languages" array should NOT contain "Angular"
    And the "languages" array should NOT contain "Vue"
    And the "languages" array should NOT contain "Java"
    And the "languages" array should NOT contain "Shell"
    And the "languages" array should NOT contain "TypeScript"
    And the "languages" array should NOT contain "Node.js"

  Scenario: GET /api/languages for an unknown project type returns 400
    When I send a GET request to "/api/languages?project_type=UnknownType"
    Then the response status should be 400
    And the response body should contain "Unknown project type"
    And the response body should contain "UnknownType"

  Scenario: UI language dropdown for Data Pipeline contains Python and Scala only
    Given I am on the wizard view
    When I select "Data Pipeline" from the element with data-testid "input-type"
    Then the element with data-testid "input-language" is enabled
    And the element with data-testid "input-language" should contain exactly 3 options
    And the element with data-testid "input-language" contains an option with text "Python"
    And the element with data-testid "input-language" contains an option with text "Scala"
    And the element with data-testid "input-language" should NOT have an option with value "React"
    And the element with data-testid "input-language" should NOT have an option with value "Java"
    And the element with data-testid "input-language" should NOT have an option with value "Shell"


# ─────────────────────────────────────────────────────────────────────────────
# TS-009  Project creation happy path — valid project name accepted
# ─────────────────────────────────────────────────────────────────────────────