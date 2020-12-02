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
### EVIDENCIA
##################################################################################

#Método para guardar la evidencia de ejecucion al momento de invocar este metodo, en este punto toda la evidencia es pass
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

#Método para guardar la evidencia de ejecucion al momento de invocar este metodo, en este punto toda la evidencia es pass
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
### ACCIONES - UI ELEMENTS
##################################################################################


#Metodo para validar si un elemento existe
# @params
# * :uielement string query que identifica un mobile element
# * :timeout tiempo maximo en segundos para esperar que exista el elemento. si no se manda to, el default es 1s
# * :msj_error en caso de un error mensaje a mostrar
# @return
# * :Boolean true => si existe el elemento, EXCEPTION => si no se encontro el elemento en el tiempo de espera "timeout"
def assert_for_uielement_exist(uielement, timeout = nil, msj_error = nil)
  element = uielement.to_s.strip
  result = false
  #si no se manda timeout por default se envia 5
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


#Método que espera que exista un elemento. Si no existe se retorna el el error
# @params
# * :element string query que identifica un mobile element
# * :timeout tiempo máximo de espera
# * :msj_error en caso de un error mensaje a mostrar en la consola
# @return
# * :Boolean true => si existe el elemento, false => si no se encontro el elemento en el tiempo de espera "timeout"
def verity_for_uielement_exist(uielement, timeout = nil, msj_error = nil)
  element = uielement.to_s.strip
  result = false
  #si no se manda timeout por default se envia 5
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




