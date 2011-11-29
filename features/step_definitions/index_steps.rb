When /^I go to (.*)$/ do |page|
  visit path_to(page)
end

Then /^I should see "([^\"]*)"$/ do |text|
  response_body.should =~ Regexp.new(Regexp.escape(text))
end

Then /^There should be a HELP image with tooltip text$/ do
  within '.help' do |scope|
    scope.should have_selector('img[title]')
  end
end

Then /^I should see a "([^"]*)" containing "([^"]*)"$/ do |arg1, arg2|
  within "#{arg1}" do |scope|
    scope.should have_selector(".#{arg2}")
  end
end
