And(/^I click "([^"]*)"$/) do |arg|
  click_link(arg)
end

And(/^I press "([^"]*)"$/) do |arg|
  click_button(arg)
end


When('I go to the TradingBotApp home page') do
  visit '/'
end

Then('I should be on the page {string}') do |string|
  expect(page).to have_title(string)
end

When ('I go to the edit page for Bot 1') do
  visit '/bots/1/edit'
end

Given /the following bots exist/ do |bots_table|
  bots_table.hashes.each do |bot|
    Bot.create bot
  end
end

When(/^I select "([^"]*)" from "([^"]*)"$/) do |arg1, arg2|
  select(arg1, :from => arg2)
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |arg1, arg2|
  fill_in(arg1, :with => arg2)
end

Then /^I should see "([^"]*)"$/ do |text|
  expect(page).to have_content(text)
end

Given /I am on the page Create Bot/ do
  visit new_bot_path
end