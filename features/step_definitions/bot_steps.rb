And(/^I click "([^"]*)"$/) do |arg|
  click_link(arg)
end

When('I go to the TradingBotApp home page') do
  visit '/'
end

Then /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end