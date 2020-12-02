require 'calabash-android/calabash_steps'
require_relative '../../../helpers/generic'
require_relative '../../../helpers/mate'

#***************************************************************
# STEPS - PAGINA LOGIN
#***************************************************************

When(/^Se muestra la pagina de 'Login'$/) do
  login_page = LoginPage.new(self)
  login_page.assert_login_page_visible
  save_evidence_execution
end

When(/^Hago login como "([^"]*)"$/) do |tipo_usuario|
  login_page = LoginPage.new(self )
  login_page.llenar_formulario_data_table(tipo_usuario)
  save_evidence_execution
  login_page.touch_boton_login
end

When(/^Se muestra el popup de 'Login exitoso'$/) do
  login_page = LoginPage.new(self)
  login_page.assert_alert_login_exitoso
  save_evidence_execution
end