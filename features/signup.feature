Feature: sign up

  As a new trader
  So that I can begin creating bots
  I want to create an account

  Background: users in database
    Given the following users exist:
    | username    | password |
    | User 1      | 123      |

  Scenario: get to sign up page
    Given I am on the TradingBotApp home page
    And I click "Sign Up"
    Then I should be on the page "Sign Up"

  Scenario: enter credentials and sign up
    Given I am on the page Sign Up
    And I fill in "user_username" with "User 2"
    And I fill in "user_password" with "123"
    And I press "commit"
    Then I should be on the page "CrypTerminator"
    And I should see "User 2"

  Scenario: enter existing credentials and sign up
    Given I am on the page Sign Up
    And I fill in "user_username" with "User 1"
    And I fill in "user_password" with "123"
    And I press "commit"
    Then I should be on the page "Sign Up"
    And I should see "Username already exists"