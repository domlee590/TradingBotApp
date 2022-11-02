Given /^the following bots:$/ do |bots|
  Bots.create!(bots.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) bots$/ do |pos|
  visit bots_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following bots:$/ do |expected_bots_table|
  expected_bots_table.diff!(tableish('table tr', 'td,th'))
end
