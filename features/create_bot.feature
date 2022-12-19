Feature: create a bot

  As a trader
  So that I can test my strategy
  I want to create and save a trading bot configuration

  Background: users in database
    Given the following users exist:
      | username    | password |
      | User 1      | 123      |

    And I am logged in as User 1

  Scenario: get to create a bot page
    Given I am on the page Your Bots
    And I click "Add New Bot Configuration"
    Then I should be on the page "Create Bot"

  Scenario: create a bot
    Given I am on the page Create Bot
    And I fill in "Bot Name" with "My Bot"
    And I select "ethusdt" from "bot_symbol"
    And I fill in "bot_ema" with "5"
    And I select "true" from "bot_short"
    And I press "Save Changes"
    Then I should be on the page "Your Bots"
    And I should see "My Bot was successfully created."
    And I should see "My Bot"

