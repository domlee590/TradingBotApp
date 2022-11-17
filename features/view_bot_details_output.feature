Feature: view a bots details and output

  As a trader
  So that I can learn about how my bot is acting
  I want to view the details and outputs of my bot

  Background: users in database

    Given the following users exist:
      | username    | password |
      | User 1      | 123      |
      | User 4      | 234      |

    And the following bots exist:
      | name        | username  | ema |
      | Bot 1       | User 1        | 5 |
      | Bot 2       | User 4        | 6 |

    And I am logged in as User 1

  Scenario: get to your bots details page
    Given I am on the page Your Bots
    And I should see "Bot 1"
    And I click "More Details"
    Then I should be on the page "View Bot"
    And I should see "Bot 1"
    And the ema of "Bot 1" should be "5"