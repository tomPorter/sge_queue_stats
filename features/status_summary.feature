Feature: Status Summary on Home page

  Scenario: Reading the Queue Stats page
    When I go to the home page
    Then I should see a status line with an entry for "Ttl"
    And I should see a status line with an entry for "r"
    And I should see a status line with an entry for "qw"
    And I should see a status line with an entry for "hqw"
    And I should see a status line with an entry for "Eqw"
    And I should see a status line with an entry for "s"
