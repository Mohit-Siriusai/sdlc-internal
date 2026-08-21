@TS-004 @regression @api @ui @demo-mode
Feature: TS-004 Language options filtered by project type - Microservice

  Background:
    Given the portal API is running at "http://localhost:8000"

  Scenario: GET /api/languages for Microservice returns exactly 3 languages
    When I send a GET request to "/api/languages?project_type=Microservice"
    Then the response status should be 200
    And the response Content-Type should contain "application/json"
    And the response JSON field "languages" is an array with exactly 3 items
    And the "languages" array contains "Java/Spring Boot"
    And the "languages" array contains "Python/Flask"
    And the "languages" array contains "Node.js"

  Scenario: GET /api/languages for Microservice does NOT include frontend or data-pipeline languages
    When I send a GET request to "/api/languages?project_type=Microservice"
    Then the response status should be 200
    And the "languages" array should NOT contain "React"
    And the "languages" array should NOT contain "Angular"
    And the "languages" array should NOT contain "Vue"
    And the "languages" array should NOT contain "Scala"
    And the "languages" array should NOT contain "Shell"
    And the "languages" array should NOT contain "TypeScript"

  Scenario: UI language dropdown for Microservice contains exactly 4 options including placeholder
    Given I am on the wizard view
    When I select "Microservice" from the element with data-testid "input-type"
    Then the element with data-testid "input-language" should contain exactly 4 options
    And the element with data-testid "input-language" contains an option with text "Java/Spring Boot"
    And the element with data-testid "input-language" contains an option with text "Python/Flask"
    And the element with data-testid "input-language" contains an option with text "Node.js"

  Scenario: UI language dropdown for Microservice does not offer frontend languages
    Given I am on the wizard view
    When I select "Microservice" from the element with data-testid "input-type"
    Then the element with data-testid "input-language" should NOT have an option with value "React"
    And the element with data-testid "input-language" should NOT have an option with value "Angular"
    And the element with data-testid "input-language" should NOT have an option with value "Vue"
    And the element with data-testid "input-language" should NOT have an option with value "Scala"


# ─────────────────────────────────────────────────────────────────────────────
# TS-005  Language options filtered by project type — Batch Job
# ─────────────────────────────────────────────────────────────────────────────