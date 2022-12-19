Feature: view your edus

  As a trader
  So that I can educate myself
  I want to view the education videos

  Background: users in database

    Given the following users exist:
      | username    | password |
      | User 1      | 123      |
      | User 4      | 234      |

    And the following edus exist:
      | id | name        | username  |
      | 1  | Coin Theorist       | User 1       |

    And I am logged in as User 1

  Scenario: get to view your bots page
    Given I am on the TradingBotApp home page
    And I click "Learn From the Pros"
    Then I should be on the page "Edus"
    And I should see "Coin Theorist"