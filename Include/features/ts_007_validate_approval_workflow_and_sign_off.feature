@TS-007 @regression @api @ui @demo-mode
Feature: TS-007 Language options filtered by project type - Library

  Background:
    Given the portal API is running at "http://localhost:8000"

  Scenario: GET /api/languages for Library returns exactly Java, Python, TypeScript
    When I send a GET request to "/api/languages?project_type=Library"
    Then the response status should be 200
    And the response JSON field "languages" is an array with exactly 3 items
    And the "languages" array contains "Java"
    And the "languages" array contains "Python"
    And the "languages" array contains "TypeScript"

  Scenario: GET /api/languages for Library does NOT include frontend or pipeline languages
    When I send a GET request to "/api/languages?project_type=Library"
    Then the response status should be 200
    And the "languages" array should NOT contain "React"
    And the "languages" array should NOT contain "Angular"
    And the "languages" array should NOT contain "Vue"
    And the "languages" array should NOT contain "Scala"
    And the "languages" array should NOT contain "Shell"
    And the "languages" array should NOT contain "Node.js"

  Scenario: UI language dropdown for Library contains Java, Python, TypeScript
    Given I am on the wizard view
    When I select "Library" from the element with data-testid "input-type"
    Then the element with data-testid "input-language" is enabled
    And the element with data-testid "input-language" should contain exactly 4 options
    And the element with data-testid "input-language" contains an option with text "Java"
    And the element with data-testid "input-language" contains an option with text "Python"
    And the element with data-testid "input-language" contains an option with text "TypeScript"
    And the element with data-testid "input-language" should NOT have an option with value "React"
    And the element with data-testid "input-language" should NOT have an option with value "Scala"


# ─────────────────────────────────────────────────────────────────────────────
# TS-008  Language options filtered by project type — Data Pipeline
# ─────────────────────────────────────────────────────────────────────────────