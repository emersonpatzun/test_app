# encoding: utf-8
require 'calabash-android/calabash_steps'
require_relative '../../../helpers/generic.rb'


#*****************************************************************************
# STEPS DEFINITIONS
#*****************************************************************************

When(/^Abro la aplicacion$/) do
  @generic_page = GenericPage.new(self)
  @generic_page.abrir_app
end

When(/^Tomo screenshot$/) do
  save_evidence_execution
end
