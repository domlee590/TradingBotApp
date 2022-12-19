Feature: view an edus details and copy it to your bots

  As a trader
  So that I can learn more about trading bots
  I want to view the details of a bot made based off an education video and copy it to your own bots

  Background: users in database

    Given the following users exist:
      | username    | password |
      | User 1      | 123      |
      | User 4      | 234      |

    And the following edus exist:
      | name        | username  |
      | Coin Theorist       | User 1       |


  Scenario: copybot
    Given I am logged in as User 1
    And I am on the details page for Coin Theorist
    And I click "Copy Bot Configuration"
    Then I should be on the page "Your Bots"
    And I should see "Coin Theorist"






