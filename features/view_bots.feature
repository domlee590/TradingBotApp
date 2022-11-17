Feature: view your bots

  As a trader
  So that I can manage my bots
  I want to view the bots I've made

  Background: users in database

    Given the following users exist:
      | username    | password |
      | User 1      | 123      |

    And the following bots exist:
        | name        | user_id  |
        | Bot 1       | 1        |
        | Bot 2       | 2        |

  Scenario: get to view your bots page
    Given I am on the TradingBotApp home page
    And I click "View Your Bots"
    Then I should be on the page "Your Bots"
    And I should see /'Bot 1'/
    And I should not see /'Bot 2'/


