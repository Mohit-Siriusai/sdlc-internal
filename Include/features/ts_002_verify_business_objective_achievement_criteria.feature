@TS-002 @regression
   Feature: Verify business objective achievement criteria

     Background:
       Given the objectives tracking service is running
       And business objective "BO-001" is defined with KPIs

     Scenario: Successfully retrieve business objective with metrics
       When I send a GET request to "/api/v1/objectives/BO-001"
       Then the response status should be 200
       And the response field "objective_id" should be "BO-001"
       And the response should contain "kpi_metrics" array
       And the response should contain "target_value" field

     Scenario: Validate KPI measurement calculation
       Given objective "BO-001" has target value 100
       When I send a POST request to "/api/v1/objectives/BO-001/measure" with body:
         """
         {"actual_value": 95, "measurement_date": "2026-08-18"}
         """
       Then the response status should be 200
       And the response field "achievement_percentage" should be 95.0
       And the response field "status" should be "on_track"

6. COVERAGE SUMMARY — at the end, provide:
   - ✅ Covered: List each TS-ID, what code implements it, and how many test cases generated
   - ❌ Skipped: List each TS-ID that was skipped and WHY (feature not found in code)
   - 📊 Overall: X of Y scenarios covered

IMPORTANT REMINDERS:
- Do NOT hallucinate endpoints or functions that don't exist in the code
- Do NOT generate test cases for features that aren't implemented
- Every Given/When/Then step should be traceable to actual code
- Use realistic test data that matches the codebase's data models
- If the project uses specific testing frameworks or patterns, follow those conventions
- These scenarios are meta-level (testing BRD/requirements management), so look for document management, workflow, approval, or project management features in the codebase
- If this is a different type of application (e.g., e-commerce, CRM), map these meta-scenarios to equivalent features (e.g., TS-007 approval workflow might map to order approval or user registration approval)