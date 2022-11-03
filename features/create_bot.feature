Feature: create a bot

  As a trader
  So that I can test my strategy
  I want to create and save a trading bot configuration

Scenario: create first bot
  When I go to the TradingBotApp home page
  And I click "View Your Bots"
  Then I should be on the page "Your Bots"
  And I click "Add new bot configuration"
  Then I should be on the page "Create Bot"
  And I fill in "Name" with "cool bot"
  And I fill in "Moving Average 1" with "1"
  And I fill in "Moving Average 2" with "4"
  And I press "Save Changes"
  Then I should be on the page "Your Bots"
  And I should see "cool bot"