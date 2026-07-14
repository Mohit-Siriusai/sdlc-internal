@regression @api @demo-mode @bug-3
Feature: FR-L12 Remove member from project

  Background:
    Given the portal API is running at "http://localhost:8000"
    And all projects have been reset via "clear state"

  Scenario: DELETE returns 200 and removed member no longer appears in GET /api/projects/{id} (AC-07)
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "remove-test",
        "project_type": "Microservice",
        "language": "Java/Spring Boot"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "alice@x.com",
        "role": "Admin"
      }
      """
    Then the response status should be 200
    When I send a DELETE request to "/api/projects/{projectId}/members/alice@x.com"
    Then the response status should be 200
    And the response JSON field "status" should equal "ok"
    When I send a GET request to "/api/projects/{projectId}"
    Then the response status should be 200
    And the "members" array should NOT contain an object where "user_email" equals "alice@x.com"

  Scenario: DELETE removes only the targeted member, leaving other members intact
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "partial-remove",
        "project_type": "Batch Job",
        "language": "Java"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "alice@x.com",
        "role": "Admin"
      }
      """
    Then the response status should be 200
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "bob@y.com",
        "role": "Developer"
      }
      """
    Then the response status should be 200
    When I send a DELETE request to "/api/projects/{projectId}/members/alice@x.com"
    Then the response status should be 200
    When I send a GET request to "/api/projects/{projectId}"
    Then the response status should be 200
    And the "members" array should NOT contain an object where "user_email" equals "alice@x.com"
    And the "members" array contains an object where "user_email" equals "bob@y.com"

  Scenario: DELETE /api/projects/{id}/members/{email} on a non-existent project returns 404
    When I send a DELETE request to "/api/projects/00000000-0000-4000-8000-000000000000/members/alice@x.com"
    Then the response status should be 404
    And the response JSON field "detail" should equal "Project not found"

  Scenario: UI Remove Member view shows updated member list after member is removed
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "ui-remove-proj",
        "project_type": "Library",
        "language": "Java"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a POST request to "/api/projects/{projectId}/members" with body:
      """
      {
        "user_email": "grace@test.com",
        "role": "Developer"
      }
      """
    Then the response status should be 200
    Given I am on the landing page
    When I click the element with data-testid "card-remove"
    And I select "ui-remove-proj" from the element with data-testid "select-project"
    Then the element with data-testid "member-list" should be visible
    When I click the element with data-testid "btn-remove-member"
    Then the element with data-testid "member-success" should be visible
    And the element with data-testid "member-success" should contain the text "grace@test.com"


# ─────────────────────────────────────────────────────────────────────────────
# FR-L13  Remove non-existent member returns 404
#
# ⚠  PLANTED BUG #3 — remove_member() returns 200 for any email because the
#    member-not-found guard is absent.  This scenario WILL FAIL.
# ─────────────────────────────────────────────────────────────────────────────

@regression @api @demo-mode @bug-3
Feature: FR-L13 Attempt to remove a member not in the project returns 404

  Background:
    Given the portal API is running at "http://localhost:8000"
    And all projects have been reset via "clear state"

  Scenario: DELETE /api/projects/{id}/members/{email} where email is not a member returns 404
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "not-found-member",
        "project_type": "Data Pipeline",
        "language": "Python"
      }
      """
    Then the response status should be 201
    When I store the response field "id" as "projectId"
    When I send a DELETE request to "/api/projects/{projectId}/members/nobody@ghost.com"
    Then the response status should be 404
    And the response JSON field "detail" should equal "Member not found"


# ─────────────────────────────────────────────────────────────────────────────
# FR-L15  Empty member list renders gracefully
# ─────────────────────────────────────────────────────────────────────────────

@regression @api @ui @demo-mode
Feature: FR-L15 Empty member list renders gracefully when a project has zero members

  Background:
    Given the portal is running at "http://localhost:8000"
    And all projects have been reset via "clear state"

  Scenario: API returns empty members array for a freshly created project
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "empty-members",
        "project_type": "Frontend App",
        "language": "Angular"
      }
      """
    Then the response status should be 201
    And the response JSON field "members" is an empty array

  Scenario: UI member list shows "No members yet" text for a project with zero members
    When I send a POST request to "/api/projects" with body:
      """
      {
        "project_name": "empty-members-ui",
        "project_type": "Frontend App",
        "language": "Angular"
      }
      """
    Then the response status should be 201
    Given I am on the landing page
    When I click the element with data-testid "card-add"
    And I select "empty-members-ui" from the element with data-testid "select-project"
    Then the element with data-testid "member-list-empty" should be visible
    And the element with data-testid "member-list-empty" should contain the text "No members yet"