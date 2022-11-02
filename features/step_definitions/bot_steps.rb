And(/^I click "([^"]*)"$/) do |arg|
  click_link(arg)
end

When('I go to the TradingBotApp home page') do
  visit '/'
end

