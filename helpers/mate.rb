# encoding: utf-8
#**********************************************
#MATE => Mobile Automation Test Extras
#**********************************************
#AUTOR: BICHO (David Chavez Avila)
#DESCIRPTION: Funciones extras para la automatizacion de apps android.
#             usando adb shell
#DEDICATORIA: Para mi amada hermana MAria TEresa Ortegon Orozco
#**********************************************

#**********************************************
#EJEMPLO XML => USE XPATH TO GET ELEMENTS ANDROID
#**********************************************

# <node index="4" text="" resource-id="com.android.systemui:id/notification_shelf_text_area" class="android.widget.LinearLayout" package="com.android.systemui" content-desc="" checkable="false" checked="false" clickable="false" enabled="true" focusable="true" focused="false" scrollable="false" long-clickable="false" password="false" selected="false" bounds="[352,1203][1080,1299]">
#   <node index="0" text="AJUSTES NOTIFICACIONES" resource-id="com.android.systemui:id/noti_setting" class="android.widget.TextView" package="com.android.systemui" content-desc="Ajustes notificaciones,BotÃ³n" checkable="false" checked="false" clickable="true" enabled="true" focusable="true" focused="false" scrollable="false" long-clickable="false" password="false" selected="false" bounds="[352,1203][799,1299]"/>
#   <node index="1" text="BORRAR" resource-id="com.android.systemui:id/clear_all" class="android.widget.TextView" package="com.android.systemui" content-desc="Borrar,BotÃ³n" checkable="false" checked="false" clickable="true" enabled="true" focusable="true" focused="false" scrollable="false" long-clickable="false" password="false" selected="false" bounds="[865,1203][1020,1299]"/>
# </node>

#**********************************************


require 'nokogiri'


#**********************************************
#**********************************************
#**********************************************
# ADB RUN COMMANDS
#**********************************************
#**********************************************
#**********************************************

#Método para ejecutar comando ADB dentro del device (adb shell)
# @params
# * :cmd comando de shell (cmd, shell, etc)
# @return
# * :Hash hash con outs de la terminal => {:stdout => stdout, :stderr => stderr, :status => status}
def adb_exec(cmd)

  require 'open3'

  if !ENV['DEVICE'].nil?
    #si tenemos la 'variable de entorno DEVICE ' entonces ejecutaremos ADB SHELL desde consola
    #   ESTO EN CASO DE NO ESTAR USANDO CALABASH
    adb_cmd = "adb -s #{ENV['DEVICE'].to_s.strip} #{cmd}"

  elsif !default_device.nil?
    #si default device no es nulo, entonces se esta usando 'CALABASH'
    adb_cmd = "#{default_device.adb_command} #{cmd}"

  else
    raise "Se necesita definir la VARIABLE DE ENTORNO 'DEVICE'. O ejecutar desde 'CALABASH CONSOLE'"

  end

  #puts "adb_cmd => #{adb_cmd}"
  stdout, stderr, status = Open3.capture3(adb_cmd)

  unless status.success?
    raise "Adb failed: #{adb_cmd} Returned #{stdout} :: #{stderr}"
  end

  [stdout, stderr, status]

end


#**********************************************
#**********************************************
#**********************************************
# OBTENER DATOS DE LOS NODOS Y ELEMENTOS MOBILE
#**********************************************
#**********************************************
#**********************************************

#REGRESA EL ARBOL DE ELEMENTOS DE LA APP
# @params
# * :cmd comando de shell (cmd, shell, etc)
# @return
# * :Hash hash con outs de la terminal => {:stdout => stdout, :stderr => stderr, :status => status}
def uiautomator_dump
  stdout, stderr, status = adb_exec('shell uiautomator dump')
  unless /dumped to: (?<file>\S*)/ =~ stdout
    raise "uiautomator dump failed? Returned #{stdout} :: #{stderr}"
  end
  stdout, stderr, status = adb_exec("shell cat #{file}")
  [stdout, stderr, status]
end


#Extrae las cordenadas x1, y1, x2, y2 del elemento
#   ACTUALMENTE SOLO TRAE LAS DEL 1ER ELEMENTO DE LA BUSQUEDA
# @params
# * :set XML PARSE
# @return
# * :matches los 4 coordenadas |x1, y1, x2, y2|
def extract_integer_bounds(set)
  return nil if set.empty?
  match = (set.attr('bounds').to_s.match(/\[(\d+),(\d+)\]\[(\d+),(\d+)\]/))
  #puts "extract_integer_bounds => match.captures =>   #{match.captures.collect(&:to_i)}"
  match.captures.collect(&:to_i)
end


#Método para obtener 1 elemento mobile apartir de su xpath
# @params
# * :xpath xpath que identifica y busca al mobile element
# @return
# * :XML string con nodo xml del elemento encontrado
def get_mobile_element(xpath)

  xpath = xpath.to_s.force_encoding(Encoding::UTF_8)
  stdout, _stderr, _status = uiautomator_dump
  set = Nokogiri::XML(stdout).xpath(xpath)

  if set.size > 1
    raise "Ambiguous match, found #{set.size} elements matching to XPATH Mobile Element => '#{xpath}'"
  end

  return set

end


#Método para obtener 1 atributo de un mobile element apartir de su xpath
# @params
# * :xpath xpath que identifica y busca al mobile element
# * :attribute atributo que se desea recuperar
# @return
# * :STRING string el atributo a recuperar
def get_mobile_element_attribute(xpath, attribute)

  stdout, _stderr, _status = uiautomator_dump
  set = Nokogiri::XML(stdout).xpath(xpath)

  if set.size > 1
    raise "Ambiguous match, found #{set.size} elements matching to XPATH Mobile Element => '#{xpath}'"
  end

  attr = set[0][attribute.to_s.strip]

  return attr

end

#Método que recupera las coordenadas del elemento |x1, y1, x2, y2|
# @params
# * :elemen XML node del mobile element
# @return
# * :bounds coordenadas del elemento |x1, y1, x2, y2|. Si no se puede extraer las coordenadas se retora "NIL"
def get_bounds_from_element(element)

  if (bounds = extract_integer_bounds(element))
    return yield bounds
  else
    return nil
  end

end


# @deprecated Please send {xpath} directly in 'mobile actions'
def bounds_from_xpath(xpath)
  stdout, _stderr, _status = uiautomator_dump
  set = Nokogiri::XML(stdout).xpath(xpath)
  #puts "bounds_from_xpath => set => #{set}"

  if (bounds = extract_integer_bounds(set))
    #puts "bounds_from_xpath => yield bounds => #{yield bounds}"
    return yield bounds
  else
    return nil
  end

end

# @deprecated Please send {xpath} directly
#Retorna el xpath del elemento a buscar
def xpath_for_full_path_texts(params)
  texts = params.keys.grep(/^notification.full./)
  clauses = texts.collect { |k| "./node/node[@text='#{params[k]}']" }
  #puts "xpath_for_full_path_texts => //node[#{clauses.join('][')}]"
  "//node[#{clauses.join('][')}]"
end


#**********************************************
#**********************************************
#**********************************************
# MOBILE ELEMENTS - ACTIONS BASE
#**********************************************
#**********************************************
#**********************************************


#ELIMINA EL CACHE DE UN APP POR MEDIO DEL "NAME PACKAGE"
# @params
# * :app_package nombre dle paquete del app
def clear_cache_mobile_app(app_package)
  stdout, stderr, status = adb_exec("shell pm clear #{app_package.to_s.strip}")
  puts "MATE => CLEAR CACHE => TRUE"

rescue Exception => e
  puts("clear_cache_mobile_app => Error al limpiar cache de la app con package: #{app_package}.
          \nException => #{e.message}
        \nConsole output => #{[stdout, stderr, status]}")
end

#LEVANTA UN APP POR MEDIO DEL "NAME PACKAGE"
# @params
# * :app_package nombre dle paquete del app
def lauch_mobile_app(app_package)
  stdout, stderr, status = adb_exec("shell monkey -p #{app_package.to_s.strip} -c android.intent.category.LAUNCHER 1")
rescue Exception => e
  raise("lauch_mobile_app => Error al lanzar la app con package: #{app_package}.
          \nException => #{e.message}
        \nConsole output => #{[stdout, stderr, status]}")
end

#Método tap en un mobile element
# @params
# * :xpath xpath que identifica y busca al mobile element
# @return
# * :Boolean
def tap_element(xpath)

  #obtener 'mobile element' form xpath
  mobile_element = get_mobile_element xpath

  if mobile_element.nil? or mobile_element.to_s.empty?
    raise "Element Not Found. XPATH => ''#{xpath}''"
  end

  begin

    found_bounds = get_bounds_from_element(mobile_element) do |x1, y1, x2, y2|
      xm = (x1 + x2) >> 1
      ym = (y1 + y2) >> 1
      adb_exec("shell input tap #{xm} #{ym}")
      #puts "ADB => shell input tap #{xm} #{ym}"
    end

    result = !found_bounds.nil?

    return result

  rescue Exception => e
    raise "tap_element => EXCEPTION => #{e.message}"

  end

end


#Método se hace tap y luego se envia text a un mobile element
# @params
# * :xpath xpath que identifica y busca al mobile element
# @return
# * :Boolean
def set_text_element(xpath, text)

  #obtener 'mobile element' form xpath
  mobile_element = get_mobile_element xpath
  result = false

  if mobile_element.nil? or mobile_element.to_s.empty?
    raise "Element Not Found. XPATH => ''#{xpath}''"
  end

  tap_element xpath

  begin

    #MANEJO DEL TEXTO - REMPLAZAR CARACTERES Y ADECUARLO PARA ENVIARLO A ADB
    text = text.to_s.strip.gsub( ' ', '%s' ) #.to_s.encode(Encoding::UTF8_SoftBank)
    text = text.to_s.strip.gsub( '"', '\"' )

    #LIMPIAR PREVIAMENTE INPUT
    #adb_exec("shell input keyevent KEYCODE_MOVE_END")
    #for i in 0..250
      #adb_exec("shell input keyevent --longpress KEYCODE_DEL")
      #adb_exec("shell input keyevent KEYCODE_DEL")
    #end

    #escribir texto en input
    #puts "text => #{text}"
    adb_exec("shell input text '#{text}'")
    result = true

  rescue Exeption => e
    raise "set_text_element => Exeption => #{e.message}"

  end

  return result

end


#Método para hacer swipe a l aderecha sobre un mobile element
#   Ej. al cerrar/ignorar notificaciones sobre la barra de notificaciones
# @params
# * :xpath xpath que identifica y busca al mobile element
# @return
# * :Boolean
def swipe_element_to_rigth(xpath)

  #obtener 'mobile element' form xpath
  mobile_element = get_mobile_element xpath

  if mobile_element.nil? or mobile_element.to_s.empty?
    raise "Element Not Found. XPATH => ''#{xpath}''"
  end

  begin

    found_bounds = get_bounds_from_element(mobile_element) do |x1, y1, x2, y2|
      ym = (y1 + y2) >> 1
      adb_exec("shell input swipe #{x1} #{ym} 10000 #{ym}")
      #puts "EXEC SHELL => shell input swipe #{x1} #{ym} 10000 #{ym}"
    end

    result = !found_bounds.nil?

    return result

  rescue Exception => e
    raise "swipe_element_to_rigth => EXCEPTION => #{e.message}"

  end

end


#Método para hacer swipe a la izquierda sobre un mobile element
#   Ej. al cerrar/ignorar notificaciones sobre la barra de notificaciones
# @params
# * :xpath xpath que identifica y busca al mobile element
# @return
# * :Boolean
def swipe_element_to_left(xpath)

  #obtener 'mobile element' form xpath
  mobile_element = get_mobile_element xpath

  if mobile_element.nil? or mobile_element.to_s.empty?
    raise "Element Not Found. XPATH => ''#{xpath}''"
  end

  begin

    found_bounds = get_bounds_from_element(mobile_element) do |x1, y1, x2, y2|
      ym = (y1 + y2) >> 1
      adb_exec("shell input swipe 10000 #{ym} #{x2} #{ym}")
      #puts "EXEC SHELL => shell input swipe #{x1} #{ym} 10000 #{ym}"
    end

    result = !found_bounds.nil?

    return result

  rescue Exception => e
    raise "swipe_element_to_rigth => EXCEPTION => #{e.message}"

  end

end


#Método para hacer scroll down en una pantalla
# @params
# * :drag_to cantidad de points a desplazar
# @return
# * :Boolean
def scroll_to_down(drag_to = nil)

  #obtener 'mobile element' form xpath
  xpath = "(//node[./node/node])[last()]"
  drag = drag_to.nil? ? 100 : drag_to.to_s.to_i

  mobile_element = get_mobile_element xpath

  if mobile_element.nil? or mobile_element.to_s.empty?
    raise "Element Not Found. XPATH => ''#{xpath}''"
  end

  begin

    found_bounds = get_bounds_from_element(mobile_element) do |x1, y1, x2, y2|
      if (x1 + y1 + x2 + y2) == 0
        screen_size = get_screen_size
        xm = screen_size[:width] >> 1
        ym = screen_size[:height]  >> 1
        yf = ym - drag
      else
        xm = (x1 + x2) >> 1
        ym = (y1 + y2) >> 1
        yf = y1 - drag
      end

      adb_exec("shell input swipe #{xm} #{ym} #{xm} #{yf}")
      #puts("shell input swipe #{xm} #{ym} #{xm} #{yf}")
    end

    result = !found_bounds.nil?

    return result

  rescue Exception => e
    raise "scroll_to_down => EXCEPTION => #{e.message}"

  end

end


#Método para hacer scroll up en una pantalla
# @params
# * :drag_to cantidad de points a desplazar
# @return
# * :Boolean
def scroll_to_up(drag_to = nil)

  #obtener 'mobile element' form xpath
  xpath = "(//node[./node/node])[1]"
  drag = drag_to.nil? ? 100 : drag_to.to_s.to_i

  mobile_element = get_mobile_element xpath

  if mobile_element.nil? or mobile_element.to_s.empty?
    raise "Element Not Found. XPATH => ''#{xpath}''"
  end

  begin

    found_bounds = get_bounds_from_element(mobile_element) do |x1, y1, x2, y2|
      xm = (x1 + x2) >> 1
      ym = (y1 + y2) >> 1
      yf = ym + drag
      adb_exec("shell input swipe #{xm} #{ym} #{xm} #{yf}")
      #puts("shell input swipe #{xm} #{ym} #{xm} #{yf}")
    end

    result = !found_bounds.nil?

    return result

  rescue Exception => e
    raise "scroll_to_down => EXCEPTION => #{e.message}"

  end

end


#Método que realiza scroll down hasta que encuentre un elemento
# @params
# * :xpath_element xpath que identifica y busca al mobile element
# * :intentos numero maximo de intentos de hacer scrolls hasta encontrar el elemento
# * :scroll_size tamaño del scroll a enviar. ej 100, 500, etc
# @return
# * :Boolean True si el elemento es encontrado, False si el elemento no se encontro despues de N scrolls
def scroll_down_for_element_exists(xpath, intentos = nil, scroll_size = nil)

  result = false
  no_scrols = intentos.nil? ? 10 : intentos

  for i in 0..no_scrols

    if mobile_element_exists xpath
      result = true
      break
    end

    scroll_to_down scroll_size

  end

  return result

end


#Método que realiza scroll up hasta que encuentre un elemento
# @params
# * :xpath_element xpath que identifica y busca al mobile element
# * :intentos numero maximo de intentos de hacer scrolls hasta encontrar el elemento
# @return
# * :Boolean True si el elemento es encontrado, False si el elemento no se encontro despues de N scrolls
def scroll_up_for_element_exists(xpath, intentos = nil, scroll_size = nil)

  result = false
  no_scrols = intentos.nil? ? 10 : intentos

  for i in 0..no_scrols

    if mobile_element_exists xpath
      result = true
      break
    end

    scroll_to_up scroll_size

  end

  return result

end


#Método para arrastrar un elemento hacia donde esta otro elemento
# @params
# * :xpath_element_origin xpath que identifica y busca al mobile element origen
# * :xpath_element_fate xpath que identifica y busca al mobile element destino
# * :duration duracion en segundos que tarda el swipe press
# @return
# * :Boolean
def drag_element_to_element(xpath_element_origin, xpath_element_fate, duration = nil)

  result = false
  mobile_element_source = get_mobile_element xpath_element_origin
  mobile_element_fate = get_mobile_element xpath_element_fate
  duration_time = duration.nil? ? 1000 : (duration.to_i * 1000)
  xm1 = nil
  ym1 = nil
  xm2 = nil
  ym2 = nil

  if mobile_element_source.nil? or mobile_element_source.to_s.empty?
    raise "Element sourse Not Found. XPATH => ''#{xpath_element_origin}''"
  end

  if mobile_element_fate.nil? or mobile_element_fate.to_s.empty?
    raise "Element fate Not Found. XPATH => ''#{xpath_element_fate}''"
  end

  begin

    fb_1 = get_bounds_from_element(mobile_element_source) do |x1, y1, x2, y2|
      xm1 = (x1 + x2) >> 1
      ym1 = (y1 + y2) >> 1
    end

    fb_2 = get_bounds_from_element(mobile_element_fate) do |x1, y1, x2, y2|
      xm2 = (x1 + x2) >> 1
      ym2 = (y1 + y2) >> 1
    end

    if !fb_1.nil? and !fb_2.nil?
      result = true
    end

    puts("shell input swipe #{xm1} #{ym1} #{xm2} #{ym2} #{duration_time}")
    adb_exec("shell input swipe #{xm1} #{ym1} #{xm2} #{ym2} #{duration_time}")

    return result

  rescue Exception => e
    raise "drag_element_to_element => EXCEPTION => #{e.message}"

  end

end


#Método para arrastrar un elemento hacia un destino X, Y
# @params
# * :xpath_element_origin xpath que identifica y busca al mobile element origen
# * :x_fate coordenada de destino X
# * :y_fate coordenada de destino Y
# * :duration duracion en milisegundos que tarda el swipe press
# @return
# * :Boolean
def drag_element_to(xpath_element_origin, x_fate, y_fate, duration = nil)

  result = false
  mobile_element_source = get_mobile_element xpath_element_origin

  duration_time = duration.nil? ? 500 : duration
  xm1 = nil
  ym1 = nil
  xm2 = x_fate
  ym2 = y_fate

  if mobile_element_source.nil? or mobile_element_source.to_s.empty?
    raise "Element sourse Not Found. XPATH => ''#{xpath_element_origin}''"
  end

  begin

    fb_1 = get_bounds_from_element(mobile_element_source) do |x1, y1, x2, y2|
      xm1 = (x1 + x2) >> 1
      ym1 = (y1 + y2) >> 1
      #puts("shell input swipe #{xm1} #{ym1} #{xm2} #{ym2} #{duration_time}")
      adb_exec("shell input swipe #{xm1} #{ym1} #{xm2} #{ym2} #{duration_time}")
    end

    result = !fb_1.nil?

    unless result
      raise "drag_element_to => Fail => no fue posible hacer scroll down => '#{xpath_element_origin}'."
    end

    return result

  rescue Exception => e
    raise "drag_element_to_element => EXCEPTION => #{e.message}"

  end

end

#Obtiene el tamaño del display del dispositivo
def get_screen_size
  #obtenemos el tamaño de la ventana
  data_size_device = adb_exec("shell wm size")
  size = Array.new
  size_device = { :width => nil, :height => nil }

#escaneamos los numeros existentes y los almacenamos en un array
  for i in 0..(data_size_device.size - 1)
    p data_size_device[i].to_s
    if data_size_device[i].to_s.include? 'size'
      data_size_device[i].to_s.scan(/\d+/) do |number|
        size.push number
      end
      break
    end
  end

  size_device = { :width => size[0].to_s.to_i, :height => size[1].to_s.to_i }

rescue Exception => e
  raise "get_screen_size => No fue posible obtener el tamaño de la pantalla.\nException => #{e.message}"

end

#**********************************************
# SEND KEY EVENTS
#**********************************************

#Método para presionar keys del teclado
# @params
# * :keyevent KEYCODE/NUM. del keyboard a enviar
def keyboard_send_keyevent(keyevent)
  adb_exec("shell input keyevent #{keyevent}")
end

#**********************************************
# NOTIFICATIONS BAR
#**********************************************

#Método que abre la barra de notificaciones de android
def open_notifications

  begin
    adb_exec("shell cmd statusbar expand-notifications")

  rescue
    adb_exec("shell input swipe 0 0 0 300")

  end

end

#Método que cierra la barra de notificaciones de android
def close_notifications_bar
  #exec_adb("shell service call statusbar 2")
  adb_exec("shell cmd statusbar collapse")
end


#**********************************************
#**********************************************
#**********************************************
# MOBILE ELEMENTS - VERIFYS/ASSERTS
#**********************************************
#**********************************************
#**********************************************

#Método para validar si un elemento mobile existe
# @params
# * :xpath_element xpath que identifica y busca al mobile element
# @return
# * :Boolean True si el elemento existe, False si el elemento no existe
def mobile_element_exists(xpath)

  result = true

  begin
    mobile_element = get_mobile_element xpath

    if mobile_element.nil? or mobile_element.to_s.empty?
      result = false
    end

  rescue Exception => e
    puts "mobile_element_exists => Exception => #{e.message}"
    result = false

  end

  return result

end


#Método que espera un timeout hasta que un elemento mobile existe
# @params
# * :xpath_element xpath que identifica y busca al mobile element
# * :timeout tiempo en segundos para esperar el mobile element
# @return
# * :Boolean True si el elemento existe, False si el elemento no existe
def wait_for_mobile_element(xpath, timeout = nil)

  result = false
  timeout = timeout.nil? ? 1 : timeout
  start = Time.new

  while (start.to_i + timeout.to_i) > Time.new.to_i
    if mobile_element_exists(xpath)
      result = true
      break
    end
  end

  return result

end


#Método que espera un timeout hasta que un elemento mobile existe
# @params
# * :xpath_element xpath que identifica y busca al mobile element
# * :msg_err mensaje de error en caso de no localizar al elemento
# * :timeout tiempo en segundos para esperar el mobile element
# @return
# * :True si el elemento existe, EXCEPTION si el elemento no existe
def assert_for_mobile_element(xpath, msg_err, timeout = nil)

  result = false
  msg_error = msg_err.nil? ? "assert_for_mobile_element => No se encontro el elemento => #{xpath}"
                            : "assert_for_mobile_element => No se encontro el elemento => #{xpath} \n'#{msg_err}'"
  timeout = timeout.nil? ? 1 : timeout
  start = Time.new

  while (start.to_i + timeout.to_i) > Time.new.to_i
    if mobile_element_exists(xpath)
      result = true
      break
    end
  end

  unless result
    raise msg_error
  end

  return result

end




