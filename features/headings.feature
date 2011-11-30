Feature: Headings on Home page

  Scenario: Reading the Queue Stats page
    When I go to the home page
    Then I should see "Queue Stats"
    And There should be a HELP image with tooltip text 
