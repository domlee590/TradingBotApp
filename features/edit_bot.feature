Feature: edit a bots details

  As a trader
  So that I can change how my bot is acting
  I want to edit the parameters of the bot

  Background: users in database

    Given the following users exist:
      | username    | password |
      | User 1      | 123      |
      | User 4      | 234      |

    And the following bots exist:
      | name        | username  | ema |
      | Bot 1       | User 1        | 5 |
      | Bot 2       | User 4        | 6 |


  Scenario: get to your bots details page
    Given I am logged in as User 1
    And I am on the view page for Bot 1
    And I should see "Bot 1"
    And I click "Edit this bot"
    Then I should be on the page "Edit Bot"
    And I fill in "Bot Name" with "Bot 1.0"
    And I press "Update Bot Info"
    Then I should be on the view page for Bot 1.0
    And I should see "Bot 1.0"





