@TS-005 @regression @api @ui @demo-mode
Feature: TS-005 Language options filtered by project type - Batch Job

  Background:
    Given the portal API is running at "http://localhost:8000"

  Scenario: GET /api/languages for Batch Job returns exactly Java, Python, Shell
    When I send a GET request to "/api/languages?project_type=Batch%20Job"
    Then the response status should be 200
    And the response JSON field "languages" is an array with exactly 3 items
    And the "languages" array contains "Java"
    And the "languages" array contains "Python"
    And the "languages" array contains "Shell"

  Scenario: GET /api/languages for Batch Job explicitly does NOT include React (AC-05)
    When I send a GET request to "/api/languages?project_type=Batch%20Job"
    Then the response status should be 200
    And the "languages" array should NOT contain "React"

  Scenario: GET /api/languages for Batch Job does NOT include any frontend, microservice, or pipeline languages
    When I send a GET request to "/api/languages?project_type=Batch%20Job"
    Then the response status should be 200
    And the "languages" array should NOT contain "Angular"
    And the "languages" array should NOT contain "Vue"
    And the "languages" array should NOT contain "TypeScript"
    And the "languages" array should NOT contain "Scala"
    And the "languages" array should NOT contain "Java/Spring Boot"
    And the "languages" array should NOT contain "Python/Flask"
    And the "languages" array should NOT contain "Node.js"

  Scenario: UI language dropdown for Batch Job does not offer React and shows correct options
    Given I am on the wizard view
    When I select "Batch Job" from the element with data-testid "input-type"
    Then the element with data-testid "input-language" is enabled
    And the element with data-testid "input-language" should contain exactly 4 options
    And the element with data-testid "input-language" contains an option with text "Java"
    And the element with data-testid "input-language" contains an option with text "Python"
    And the element with data-testid "input-language" contains an option with text "Shell"
    And the element with data-testid "input-language" should NOT have an option with value "React"


# ─────────────────────────────────────────────────────────────────────────────
# TS-006  Language options filtered by project type — Frontend App
# ─────────────────────────────────────────────────────────────────────────────