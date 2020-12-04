#####################################################
#Descripcion:  Helper to get the csv data           #
#####################################################

require 'fileutils'
require 'yaml'


#####################################################
# READ YML DATA
#####################################################

#Method to get the data from a csv in hash map
# @params:
#   :yml_file name of the yml file to be loaded
def get_yml_data(yml_file)
  file = nil

  #get the path and name of the csv file
  if yml_file.to_s.include? '.yml'
    file =  File.join(File.dirname(__FILE__), "../venture/config/yml_data/#{yml_file}")
  elsif (
    file = File.join(File.dirname(__FILE__), "../venture/config/yml_data/#{yml_file}.yml")
  )
  end

  return YAML.load(File.read(file))

end

