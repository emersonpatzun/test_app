require 'fileutils'
require_relative 'config'


##################################################################################
### UTILERIAS
##################################################################################

#Método que obtiene un numero unico apartir del timestamps
def timestamps
  (Time.now.to_f * 1000).to_i
end

#Método que obtiene la fecha en formato HORA,MINUTO,SEGUNDO
def datetime
  Time.now.strftime('%H%M%S').to_s
end

#Método que obtiene la fecha en formato HORA,MINUTO,SEGUNDO
def date
  Time.now.strftime('%Y%m%d').to_s
end

#Método que genera un email de forma random, apartir de la fecha
def email_random
  return "test.#{timestamps}@test.com"
end


#Método que quita caracteres especiales a un string
def special_chars_replace(string_value)
  string_value = string_value.to_s.tr(':', '')
  string_value = string_value.to_s.tr('-', '')
  string_value = string_value.to_s.tr(',', '') # ,
  string_value = string_value.to_s.tr('.', '')
  string_value = string_value.to_s.tr('"', '')
  string_value = string_value.to_s.tr( ';', '' )
  string_value = string_value.to_s.tr( '(', '' )
  string_value = string_value.to_s.tr( ')', '' )
  string_value = string_value.to_s.tr( '{', '' )
  string_value = string_value.to_s.tr( '}', '' )
  string_value = string_value.to_s.tr( '[', '' )
  string_value = string_value.to_s.tr( ']', '' )
  string_value = string_value.to_s.tr( '!', '' )
  string_value = string_value.to_s.tr( '@', '' )
  string_value = string_value.to_s.tr( '#', '' )
  string_value = string_value.to_s.tr( '$', '' )
  string_value = string_value.to_s.tr( '%', '' )
  string_value = string_value.to_s.tr( '&', '' )
  string_value = string_value.to_s.tr( '/', '' )
  string_value = string_value.to_s.tr( '?', '' )
  string_value = string_value.to_s.tr( '¿', '' )
  string_value = string_value.to_s.tr( '=', '' )
  string_value = string_value.to_s.tr( '>', '' )
  string_value = string_value.to_s.tr( 'á', 'a' )
  string_value = string_value.to_s.tr( 'é', 'e' )
  string_value = string_value.to_s.tr( 'í', 'i' )
  string_value = string_value.to_s.tr( 'ó', 'o' )
  string_value = string_value.to_s.tr( 'ú', 'u' )
  string_value = string_value.to_s.tr( ' ', '_' )
  return string_value.to_s.downcase.strip
end


##################################################################################
### EVIDENCE
##################################################################################

#Method to save the execution evidence when invoking this method, at this point all the evidence is pass
def save_evidence_execution
  begin
    feature_name = special_chars_replace(Config.current_feature.to_s.downcase.strip)
    scenario_name = special_chars_replace(Config.current_scenario.to_s.downcase.strip)

    evidence_dir = "#{Config.path_results}/evidencia/#{feature_name}/#{scenario_name.to_s}/"
    evidence_name = "#{timestamps}_pass.png"

    FileUtils::mkdir_p evidence_dir unless Dir.exist? evidence_dir
    screenshot_embed({:prefix=>evidence_dir, :name=>"#{evidence_name}"})

  rescue Exception => e
    puts "Error => save_evidence_execution => #{e.message}"
    log "Error => save_evidence_execution => #{e.message}"
  end
end

#Method to save the execution evidence when invoking this method, at this point all the evidence is pass
def save_evidence_execution_fail
  begin
    feature_name = special_chars_replace(Config.current_feature.to_s.downcase.strip)
    scenario_name = special_chars_replace(Config.current_scenario.to_s.downcase.strip)
    device = special_chars_replace(Config.device.to_s.downcase.strip)

    evidence_dir = "#{Config.path_results}/evidencia/#{feature_name}/#{scenario_name.to_s}/"
    evidence_name = "#{timestamps}_fail.png"

    FileUtils::mkdir_p evidence_dir unless Dir.exist? evidence_dir
    screenshot_embed({:prefix=>evidence_dir, :name=>"#{evidence_name}"})

  rescue Exception => e
    puts "Error => save_evidence_execution => #{e.message}"
  end
end



##################################################################################
### ACTIONS - UI ELEMENTS
##################################################################################


#Method to validate if an element exists
# @params
# * :uielement string query that identifies a mobile element
# * :timeout maximum time in seconds to wait for the element to exist. if to is not sent, the default is 1s
# * :msj_error in case of an error message to display
# @return
# * :Boolean true => if the element exists, EXCEPTION => if the item was not found within the timeout "timeout"
def assert_for_uielement_exist(uielement, timeout = nil, msj_error = nil)
  element = uielement.to_s.strip
  result = false
  #if timeout is not sent by default, 5 is sent
  timeout = timeout.nil? ? 1 : timeout.to_i
  start = Time.new

  while (start.to_i + timeout.to_i) > Time.new.to_i
    if element_exists(element)
      #puts "element exist => #{element}"
      result = true
      break
    end
  end

  unless result
    raise("assert_for_uielement_exist => TimeOut al buscar: #{element}. \n#{msj_error}")
  end

  return result

end


#Method that expects an element to exist. If it does not exist, the error is returned
# @params
# * :element string query that identifies a mobile element
# * :timeout maximum waiting time
# * :msj_error in case of an error message to be displayed on the console
# @return
# * :Boolean true => if the item exists, false => if the item was not found in the timeout "timeout"
def verity_for_uielement_exist(uielement, timeout = nil, msj_error = nil)
  element = uielement.to_s.strip
  result = false
  #If timeout is not sent by default, 5 is sent
  timeout = timeout.nil? ? 1 : timeout.to_i
  start = Time.new

  while (start.to_i + timeout.to_i) > Time.new.to_i
    if element_exists(element)
      #puts "element exist => #{element}"
      result = true
      break
    end
  end

  unless result
    puts("verity_for_uielement_exist => TimeOut al buscar: #{element}. \n#{msj_error}")
  end

  return result

end




