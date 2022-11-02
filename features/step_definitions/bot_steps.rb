And(/^I click "([^"]*)"$/) do |arg|
  click_link(arg)
end

When('I go to the TradingBotApp home page') do
  visit '/'
end

#expect to be on the home page
Then('I should be on the page {string}') do |string|
  expect(page).to have_title(string)
end