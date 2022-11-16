Feature: login

  As a trader
  So that I can access and edit my created bots
  I want to login to my account

  Scenario: get to login page
    When I go to the TradingBotApp home page
    And I click "Login"
    Then I should be on the page "Your Bots"
    And I click "Add new bot configuration"
    Then I should be on the page "Create Bot"

  Scenario: create a bot
    Given I am on the page Create Bot
    And I fill in "Bot Name" with "My Bot"
    And I fill in "Moving Average 1" with "10"
    And I fill in "Moving Average 2" with "20"
    And I select "true" from "Short"
    And I press "Save Changes"
    Then I should be on the page "Your Bots"
    And I should see "My Bot"
    And I click "More Details"
    Then I should be on the page "View Bot"
    And I should see "My Bot"
    And I should see "10"
    And I should see "20"
    And I should see "true"