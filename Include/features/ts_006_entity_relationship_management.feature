@TS-006 @regression @api @ui @demo-mode
Feature: TS-006 Language options filtered by project type - Frontend App

  Background:
    Given the portal API is running at "http://localhost:8000"

  Scenario: GET /api/languages for Frontend App returns exactly React, Angular, Vue
    When I send a GET request to "/api/languages?project_type=Frontend%20App"
    Then the response status should be 200
    And the response JSON field "languages" is an array with exactly 3 items
    And the "languages" array contains "React"
    And the "languages" array contains "Angular"
    And the "languages" array contains "Vue"

  Scenario: GET /api/languages for Frontend App does NOT include backend or pipeline languages
    When I send a GET request to "/api/languages?project_type=Frontend%20App"
    Then the response status should be 200
    And the "languages" array should NOT contain "Java"
    And the "languages" array should NOT contain "Python"
    And the "languages" array should NOT contain "Shell"
    And the "languages" array should NOT contain "Scala"
    And the "languages" array should NOT contain "TypeScript"
    And the "languages" array should NOT contain "Java/Spring Boot"

  Scenario: UI language dropdown for Frontend App contains React, Angular, and Vue
    Given I am on the wizard view
    When I select "Frontend App" from the element with data-testid "input-type"
    Then the element with data-testid "input-language" is enabled
    And the element with data-testid "input-language" should contain exactly 4 options
    And the element with data-testid "input-language" contains an option with text "React"
    And the element with data-testid "input-language" contains an option with text "Angular"
    And the element with data-testid "input-language" contains an option with text "Vue"
    And the element with data-testid "input-language" should NOT have an option with value "Java"
    And the element with data-testid "input-language" should NOT have an option with value "Python"


# ─────────────────────────────────────────────────────────────────────────────
# TS-007  Language options filtered by project type — Library
# ─────────────────────────────────────────────────────────────────────────────