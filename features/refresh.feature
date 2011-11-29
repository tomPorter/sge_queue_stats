Feature: Refresh Rate

  Scenario: Refresh links exist
    When I go to the home page
    Then I should see "Slower"
    And  I should see "Refresh Rate"
    And  I should see "Faster"
