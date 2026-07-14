@TS-003 @regression @ui @demo-mode
Feature: TS-003 Language dropdown disabled until project type is selected

  Background:
    Given the portal is running at "http://localhost:8000"

  Scenario: Language dropdown (data-testid=input-language) is disabled on wizard load
    Given I am on the wizard view
    Then the element with data-testid "input-language" should be disabled

  Scenario: Language dropdown shows placeholder text before any type is selected
    Given I am on the wizard view
    Then the first option of the element with data-testid "input-language" should have text "— select a project type first —"

  Scenario: Language dropdown becomes enabled after a project type is chosen
    Given I am on the wizard view
    When I select "Microservice" from the element with data-testid "input-type"
    Then the element with data-testid "input-language" is not disabled

  Scenario: Language dropdown re-disables when project type selection is cleared to blank
    Given I am on the wizard view
    When I select "Microservice" from the element with data-testid "input-type"
    And the element with data-testid "input-language" is enabled
    When I select the blank placeholder option from the element with data-testid "input-type"
    Then the element with data-testid "input-language" should be disabled

  Scenario: Language dropdown placeholder resets to "select a language" after type is cleared
    Given I am on the wizard view
    When I select "Library" from the element with data-testid "input-type"
    And I select the blank placeholder option from the element with data-testid "input-type"
    Then the first option of the element with data-testid "input-language" should have value ""


# ─────────────────────────────────────────────────────────────────────────────
# TS-004  Language options filtered by project type — Microservice
#
# ⚠  DEFECT: LANGUAGES_BY_TYPE["Microservice"] in app.py is missing "Node.js".
#    API returns ["Java/Spring Boot", "Python/Flask"] — only 2 items.
#    Scenarios asserting count=3 or presence of "Node.js" will FAIL until fixed.
# ─────────────────────────────────────────────────────────────────────────────