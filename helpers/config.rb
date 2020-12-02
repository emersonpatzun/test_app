#####################################################
#Autor: BICHO, TETE
#Descripcion:  Helper de configuracion general
#####################################################

class Config

  #************************************************************************************
  # VARIABLES
  #************************************************************************************
  #Driver de la ejecucion selenium / chromedriver / appium
  @driver = ENV['DRIVER'].nil? ? 'chrome' : ENV['DRIVER'].to_s.downcase.strip
  #UUID del dispositivo
  @device = ENV['DEVICE'].nil? ? 'ANY_DEVICE' : ENV['DEVICE'].to_s.strip
  #Nombre del dispositivo
  @device_name = ENV['DEVICE_NAME'].nil? ? 'ANY_DEVICE_NAME' : ENV['DEVICE_NAME'].to_s.downcase.strip
  #Fecha de ejecucion este valor podria ser usado para crear la carpeta que contenga reporte y evidencia.
  @exec_date = Time.now.strftime("%Y%m%d")
  #Hora de ejecucion este valor podria ser usado para crear la carpeta que contenga reporte y evidencia.
  @exec_time = Time.now.strftime("%H%M")
  #obtiene el directorio de resultados seteado como variable de entorno
  #   de no existir la variable se usa un directorio default
  @path_results = ENV['PATH_RESULTS'].nil? ? "evidencia/#{@exec_date}/#{@exec_time}" : "#{ENV['PATH_RESULTS'].to_s.downcase.strip}"
  #obtiene el directorio para almacenar screenshots
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
