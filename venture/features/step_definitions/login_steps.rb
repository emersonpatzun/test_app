require 'calabash-android/calabash_steps'
require_relative '../../../helpers/generic'
require_relative '../../../helpers/mate'

#***************************************************************
# STEPS - LOGIN PAGE
#***************************************************************
Then(/^the 'Login' page is displayed$/) do
  login_page = LoginPage.new(self)
  login_page.assert_login_page_visible
  save_evidence_execution
end

When(/^I login as "([^"]*)"$/) do |user_type|
  login_page = LoginPage.new(self)
  login_page.fill_data_table_form(user_type)
  save_evidence_execution
  login_page.touch_button_login
end

Then(/^The 'Login Successful' popup is displayed$/) do
  login_page = LoginPage.new(self)
  login_page.assert_alert_login_successful
  save_evidence_execution
end
