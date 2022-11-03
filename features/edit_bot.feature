Feature: edit a bot

As a trader
So that I can edit my strategy
I want to edit an existing trading bot configuration

Background: bots in database

  Given the following bots exist:
    | name        | movingAverage1 | movingAverage2     | short |
    | Bot 1       | 1              | 3                  |  true |
    | Bot 2       | 4              | 7                  | false |
    | Bot 3       | 5              | 6                  |  true |



Scenario: edit moving average 1 to existing bot
  When I go to the edit page for Bot 1
  And I fill in "Moving Average 1" with "2"
  And  I press "Update Bot Info"
  Then the movingAverage1 of "Bot 1" should be "2"
  And I should be on the view page for Bot 1