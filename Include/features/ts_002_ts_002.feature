@TS-002 @regression @api @demo-mode
Feature: TS-002 Project type dropdown populated from GET /api/project-types

  Background:
    Given the portal API is running at "http://localhost:8000"

  Scenario: GET /api/project-types returns 200 with a list of exactly 5 project types
    When I send a GET request to "/api/project-types"
    Then the response status should be 200
    And the response Content-Type should contain "application/json"
    And the response body should have a top-level key "project_types"
    And the response JSON field "project_types" is an array with exactly 5 items
    And the "project_types" array contains "Microservice"
    And the "project_types" array contains "Batch Job"
    And the "project_types" array contains "Frontend App"
    And the "project_types" array contains "Library"
    And the "project_types" array contains "Data Pipeline"

  Scenario: UI project-type dropdown contains all five supported project types
    Given I am on the wizard view
    Then the element with data-testid "input-type" contains an option with text "Microservice"
    And the element with data-testid "input-type" contains an option with text "Batch Job"
    And the element with data-testid "input-type" contains an option with text "Frontend App"
    And the element with data-testid "input-type" contains an option with text "Library"
    And the element with data-testid "input-type" contains an option with text "Data Pipeline"

  Scenario: GET /api/project-types does not include fabricated or out-of-scope types
    When I send a GET request to "/api/project-types"
    Then the response status should be 200
    And the "project_types" array should NOT contain "API Gateway"
    And the "project_types" array should NOT contain "Mobile App"
    And the "project_types" array should NOT contain "Monolith"


# ─────────────────────────────────────────────────────────────────────────────
# TS-003  Language dropdown remains disabled until project type is selected
# ─────────────────────────────────────────────────────────────────────────────