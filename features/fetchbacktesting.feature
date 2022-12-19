Feature: view an edus details and fetch the backtesting data

As a trader
So that I can learn more about trading bots
I want to view the performance of the education trading bots

Background: users in database

  Given the following users exist:
  | username    | password |
  | User 1      | 123      |
  | User 4      | 234      |

  And the following edus exist:
  | id | name        | username  |
  | 1  | Coin Theorist       | User 1       |


  And the following EduOuts exist:
  | edu_id | time | pnl | wr | tc |
  | 1      | 2022 | 1 | 1 | 1 |
  | 1      | 2023 | 2 | 2 | 2 |
  | 1      | 2024 | 3 | 3 | 3 |


Scenario: fetch backtest data
  Given I am logged in as User 1
  And I am on the details page for Coin Theorist
  And I should see "Fetch BackTest for This Bot"
  And I click "Fetch BackTest for This Bot"
  Then I should see "Profit Net Loss"
  And I should see "Trade Count"
  And I should see "Win Rate"
  Then I should see "Reset BackTest"
  And I click "Reset BackTest"
  Then I should not see "Profit Net Loss"
  And I should not see "Trade Count"
  And I should not see "Win Rate"
  Then I should see "Fetch BackTest for This Bot"
