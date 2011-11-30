Then /^There should be a HELP image with tooltip text$/ do
  page.should have_selector('.help img[title]')
end

Then /^I should see a "([^"]*)" containing "([^"]*)"$/ do |arg1, arg2|
  #page.should have_selector("#{arg1} .#{arg2}")
  within "#{arg1}" do |scope|
    scope.should have_selector(".#{arg2}")
  end
end

Then /^I should see the following headings$/ do |table|
  # table is a Cucumber::Ast::Table  
  pending
end
