Feature: create a bot

  As a trader
  So that I can test my strategy
  I want to create and save a trading bot configuration

Scenario: add director to existing movie
  When I go to the edit page for "Alien"
  And  I fill in "Director" with "Ridley Scott"
  And  I press "Update Movie Info"
  Then the director of "Alien" should be "Ridley Scott"

Scenario: create first bot
  When I go to the home page
  And I click "Create a Bot"
  Then I should be on the create bots page