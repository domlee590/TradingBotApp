When('I go to the TradingBotApp home page') do
  visit '/'
end

And(/^I press "([^"]*)"$/) do |arg|
  click_link(arg)
end

Then /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end