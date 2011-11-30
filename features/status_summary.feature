Feature: Status Summary on Home page

  Scenario: Reading the Queue Stats page
    When I go to the home page
    Then I should see a status line with the following entries:
      | Ttl | r | qw | hqw | Eqw | s |
