Feature: login

  As a trader
  So that I can access and edit my created bots
  I want to login to my account

  Background: users in database

    Given the following users exist:
      | username    | password |
      | User 1      | 123             |
      | User 2      | 111             |
      | User 3      | 54321           |

  Scenario: get to login page
    Given I am on the TradingBotApp home page
    And I click "Login"
    Then I should be on the page "Login"

  Scenario: enter valid credentials and login
    Given I am on the page Login
    And I fill in "username" with "User 1"
    And I fill in "password" with "123"
    And I press "Login"
    Then I should be on the page "Home"
    And I should see "User 1"

  Scenario: enter invalid credentials
    Given I am on the page Login
    And I fill in "username" with "User 1"
    And I fill in "password" with "12345"
    And I press "Login"
    Then I should be on the page "Login"
    And I should see "Invalid username or password"