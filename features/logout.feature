Feature: logout

  As a trader
  So that I can view bots in a different account
  I want to logout of the current account

  Background: users in database

    Given the following users exist:
      | username    | password |
      | User 1      | 123      |

    And I am logged in as User 1

  Scenario: logout of user
    Given I am on the TradingBotApp home page
    And I click "Log Out"
    Then I should see "Log In"
