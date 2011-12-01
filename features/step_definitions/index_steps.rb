Then /^There should be a HELP image with tooltip text$/ do
  page.should have_selector('.help img[title]')
end

Then /^I should see a "([^"]*)" containing at least one "([^"]*)"$/ do |arg1, arg2|
  page.should have_selector("#{arg1} .#{arg2}")
  #within "#{arg1}" do |scope|
  #  scope.should have_selector(".#{arg2}")
  #end
end

Then /^I should see the following headings:$/ do |expected_headers|
  # table is a Cucumber::Ast::Table  
  header_row_columns = find('thead').all('tr')
  real_headers = header_row_columns.map {|r| r.all('th').map {|c| c.text.strip } }
  expected_headers.diff!(real_headers)
end

Then /^I should see a status line with an entry for "([^"]*)"$/ do |arg1|
   #status_link = page.find("p.summary span.#{arg1}")
   page.should have_selector("p.summary span.#{arg1}")
end
