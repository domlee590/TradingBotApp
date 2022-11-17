Feature: delete a bot

  As a trader
  So that I can remove an unused trading bot
  I want to delete an existing trading bot configuration

  Background: bots in database

    Given the following users exist:
      | username    | password |
      | User 1      | 123      |
      | User 4      | 234      |

    And the following bots exist:
      | name        | username  |
      | Bot 1       | User 1        |
      | Bot 2       | User 4        |

    And the following bot_outputs exist
      | bot_id | pnl |
      | Bot 1  | 100 |

    And I am logged in as User 1

  Scenario: delete existing bot
    When I go to the details page for Bot 1
    And I click "Delete"
    Then I should be on the page "Your Bots"
    And I should see "Bot 'Bot 1' deleted."
