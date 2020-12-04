#####################################################
#Descripcion:  Helper de configuracion general
#####################################################

class Config

  #************************************************************************************
  # VARIABLES
  #************************************************************************************
  #Selenium execution driver / chromedriver / appium
  @driver = ENV['DRIVER'].nil? ? 'chrome' : ENV['DRIVER'].to_s.downcase.strip
  #device UUID
  @device = ENV['DEVICE'].nil? ? 'ANY_DEVICE' : ENV['DEVICE'].to_s.strip
  #Device Name
  @device_name = ENV['DEVICE_NAME'].nil? ? 'ANY_DEVICE_NAME' : ENV['DEVICE_NAME'].to_s.downcase.strip
  #Execution date this value can be used to create the folder containing the report and evidence
  @exec_date = Time.now.strftime("%Y%m%d")
  #Execution time this value could be used to create the folder containing report and evidence.
  @exec_time = Time.now.strftime("%H%M")
  #Gets the results directory set as an environment variable
  #If the variable does not exist, a default directory is used
  @path_results = ENV['PATH_RESULTS'].nil? ? "evidencia/#{@exec_date}/#{@exec_time}" : "#{ENV['PATH_RESULTS'].to_s.downcase.strip}"
  #Gets the directory to store screenshots
  @current_feature = nil
  @current_scenario = nil
  @path_evidencia = "#{@path_results}/evidencia"


  #****************************************************
  #CLASS SELF
  #****************************************************
  class << self
    attr_reader :driver, :exec_time, :device, :device_name, :exec_date, :path_results, :current_feature, :current_scenario, :path_evidencia
    attr_writer :driver, :exec_time, :device, :device_name, :exec_date, :path_results, :current_feature, :current_scenario, :path_evidencia

    def to_s
      s = StringIO.new
      s << "@driver = #{@driver}, "
      s << "@device = #{@device}, "
      s << "@device_name = #{@device_name}, "
      s << "@exec_date = #{@exec_date}, "
      s << "@exec_time = #{@exec_time}, "
      s << "@path_results = #{@path_results}, "
      s << "@current_feature = #{@current_feature}, "
      s << "@current_scenario = #{@current_scenario}, "
      s << "@path_evidencia = #{@path_evidencia}"
      return s.string.to_s.strip
    end


  end

end
