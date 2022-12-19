And(/^I click "([^"]*)"$/) do |arg|
  click_link(arg)
end

And(/^I press "([^"]*)"$/) do |arg|
  click_button(arg)
  puts(page.title)
end


Given('I am on the TradingBotApp home page') do
  visit '/'
end

Then('I should be on the page {string}') do |string|
  expect(page).to have_title(string)
end

And('I am on the page {string}') do |string|
  expect(page).to have_title(string)
end

And('I am on the page Edus') do
  visit "/edus"
end

Given('I am on the page Login') do
  visit "/login"
end

Given('I am on the page Your Bots') do
  visit "/bots"
end

Given('I am on the page Sign Up') do
  visit new_user_path
end

When ('I go to the details page for Bot 1') do
  visit bot_path(Bot.find_by_name("Bot 1"))
end

And ('I am on the details page for Coin Theorist') do
  visit edu_path(Edu.find_by_name("Coin Theorist"))
end

And ('I should be on the view page for Bot 1') do
  visit bot_path(Bot.find_by_name("Bot 1"))
end

And ('I am on the view page for Bot 1') do
  visit bot_path(Bot.find_by_name("Bot 1"))
end

And ('I should be on the view page for Bot 1.0') do
  visit bot_path(Bot.find_by_name("Bot 1.0"))
end

Given /the following bots exist/ do |bots_table|
  bots_table.hashes.each do |bot|
    Bot.create bot
  end
end

Given /the following EduOuts exist/ do |edu_outs_table|
  edu_outs_table.hashes.each do |edu_out|
    EduOut.create edu_out
  end
end

Given /the following edus exist/ do |edus_table|
  edus_table.hashes.each do |edu|
    Edu.create edu
  end
end

Given /the following users exist/ do |user_table|
  user_table.hashes.each do |user|
    User.create user
  end
end

Given /the following bot_outputs exist/ do |bot_output_table|
  bot_output_table.hashes.each do |bot_output|
    bot_output[:bot_id] = Bot.find_by_name(bot_output[:bot_id]).id
    BotOut.create bot_output
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

Then /^I should not see "([^"]*)"$/ do |text|
  expect(page).to_not have_content(text)
end

Given /I am on the page Create Bot/ do
  visit new_bot_path
end

And(/^the ema of "([^"]*)" should be "([^"]*)"$/) do |arg1, arg2|
  expect(Bot.find_by_name(arg1).ema == arg2)
end


And "I am logged in as User 1" do
  visit "/login"
  fill_in(:username, :with => "User 1")
  fill_in(:password, :with => "123")
  click_button("Login")
end

And "I am logged out" do
  click_button("Logout")
end
