#####################################################
#Autor: Testingit                                   #
#Descripcion:  Helper para obtener los datos del csv#
#####################################################

require 'fileutils'
require 'yaml'


#####################################################
# READ YML DATA
#####################################################

#Metodo obtener la data de un csv en hash map
# @params:
#   :yml_file nobre del archivo yml que se va cargar
def get_yml_data(yml_file)
  file = nil

  #obtiene el path y nombre del archivo csv
  if yml_file.to_s.include? '.yml'
    file =  File.join(File.dirname(__FILE__), "../venture/config/yml_data/#{yml_file}")
  elsif (
    file = File.join(File.dirname(__FILE__), "../venture/config/yml_data/#{yml_file}.yml")
  )
  end

  return YAML.load(File.read(file))

end

