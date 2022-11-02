Feature: create a bot

  As a trader
  So that I can test my strategy
  I want to create and save a trading bot configuration

Scenario: create first bot
  When I go to the TradingBotApp home page
  And I press "Create a Bot"
  Then I should be on the create bots page