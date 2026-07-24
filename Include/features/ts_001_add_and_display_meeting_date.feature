@TS-001 @regression @api @demo-mode
Feature: TS-001 Landing page renders wizard-based UI with three action cards

  Background:
    Given the portal is running at "http://localhost:8000"
    And all projects have been reset via "clear state"

  Scenario: GET / returns HTTP 200 with HTML content type
    When I send a GET request to "/"
    Then the response status should be 200
    And the response Content-Type should contain "text/html"

  Scenario: GET / response body contains the three action-card labels
    When I send a GET request to "/"
    Then the response status should be 200
    And the response body should contain "Create Project"
    And the response body should contain "Add Member"
    And the response body should contain "Remove Member"

  Scenario: Landing page contains all three action cards with correct data-testid attributes (AC-08)
    Given I am on the landing page
    Then the page contains a button with data-testid "card-create"
    And the page contains a button with data-testid "card-add"
    And the page contains a button with data-testid "card-remove"

  Scenario: Landing page project list renders empty state when no projects exist (AC-09)
    Given I am on the landing page
    Then the element with data-testid "project-list" should be visible
    And the element with data-testid "project-list-empty" should be visible
    And the element with data-testid "project-list-empty" should contain the text "No projects yet"

  Scenario: Clicking the Create Project card opens the wizard view
    Given I am on the landing page
    When I click the element with data-testid "card-create"
    Then the element with data-testid "input-type" should be visible
    And the element with data-testid "input-language" should be visible
    And the element with data-testid "input-name" should be visible
    And the element with data-testid "btn-submit" should be visible

  Scenario: Clicking the Add Member card opens the members view
    Given I am on the landing page
    When I click the element with data-testid "card-add"
    Then the element with data-testid "select-project" should be visible
    And the element with data-testid "input-member-email" should be visible
    And the element with data-testid "input-member-role" should be visible

  Scenario: Clicking the Remove Member card opens the members view with no add-member form
    Given I am on the landing page
    When I click the element with data-testid "card-remove"
    Then the element with data-testid "select-project" should be visible
    And the element with data-testid "member-list" should be visible


# ─────────────────────────────────────────────────────────────────────────────
# TS-002  Project type dropdown populated from GET /api/project-types
# ─────────────────────────────────────────────────────────────────────────────