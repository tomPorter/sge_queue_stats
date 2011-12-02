Feature: Status Summary on Home page

  Scenario: Reading the Queue Stats page
    When I go to the home page
    Then I should see an entry for "Ttl" in the summary status line
    And I should see an entry for "r" in the summary status line
    And I should see an entry for "qw" in the summary status line
    And I should see an entry for "hqw" in the summary status line
    And I should see an entry for "Eqw" in the summary status line
    And I should see an entry for "s" in the summary status line
