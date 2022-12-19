Feature: view an edus details and output

  As a trader
  So that I can learn more about trading bots
  I want to view the details of a bot made based off an education video

  Background: users in database

    Given the following users exist:
      | username    | password |
      | User 1      | 123      |
      | User 4      | 234      |

    And the following edus exist:
      | id | channel        | name | username  |
      | 1  | Coin Theorist       | Coin Theorist | User 1       |


  Scenario: get to your bots details page
    Given I am logged in as User 1
    And I am on the page Edus
    And I should see "Coin Theorist"
    And I click "More Details"
    Then I should be on the page "View Edu"
    And I should see "Coin Theorist"






