require 'calabash-android/management/adb'
require 'calabash-android/operations'
require_relative '../../../../helpers/generic'
require_relative '../../../../helpers/mate'
require_relative '../../../../helpers/config'

#*****************************************************
# BEFORE SCENARIO
#*****************************************************
Before do |scenario|
  #Recupera el nombre del feautre, para tomar evidencia dentro de los step
  Config.current_feature = scenario.feature.name
  #Recupera el nombre del scenario, para tomar evidencia dentro de los step
  Config.current_scenario = scenario.name

  #clear_app_data
  #puts "CLEAR APP DATA"
  ##clear_cache_mobile_app 'com.mate_app'
  ##puts "CLEAR APP DATA MATE"
  #reinstall_test_server
  #puts "REINSTALL TEST SERVER"
  #start_test_server_in_background
  #puts "START TEST SERVER"
end


#*****************************************************
# AFTER SCENARIO
#*****************************************************
After do |scenario|
  if scenario.failed?
    if scenario.exception.message == "HTTPClient::KeepAliveDisconnected" || scenario.exception.message == "EOFError"
      puts "*********HTTP error!! attempting to restart test server!*************"
      reinstall_test_server
      start_test_server_in_background
    end
  end
  if scenario.failed?
    save_evidence_execution_fail
  end
  shutdown_test_server
  puts "SHUTDOWN TEST SERVER"
end


#*****************************************************
# AFTER STEP
#*****************************************************
AfterStep do |result, test_step|
  puts "AFTER STEP"
  #puts "test_step => #{test_step}"
  #puts "result => #{result.failed? ? 'fail' : 'pass'}"
end

