Feature:  Jobs Table

  Scenario: Reading the Queue Stats page
    When I go to the home page
    Then I should see a "tbody" containing at least one "job"
    And I should see the following headings:
      | qsid | clientcode | jobid | command | state | user | start_date | start_time | run_time | wait_qsid | thread | queue_name |
    And the following headings should be the only clickable links:
      | clientcode | jobid | state | user | queue_name |
