
# encoding: utf-8
require 'calabash-android/abase'
require_relative '../../../../helpers/generic'
require_relative '../../../../helpers/csv_data'
require_relative '../../../../helpers/yml_data'
require_relative '../../../../helpers/mate'


class LoginPage < Calabash::ABase

  #############################################################################
  # MOBILE ELEMENTS
  #############################################################################
  def initialize(world)
    super(world)
    #DATA CSV
    @dt_login = get_csv_data('dt_login.csv')

    #DATA YML
    @dt_yml = get_yml_data('dt_yml')

    #UIELEMENTS
    @txt_usuario = "android.widget.EditText id:'txtUsuario'"
    @txt_password = "android.widget.EditText id:'txtPassword'"
    @btn_login = "android.widget.Button id:'btnLogin'"
    @lbl_titulo_alert = "* id:'alertTitle'"
    @btn_aceptar_alert = "* text:'Aceptar'"
  end

  #############################################################################
  # ACCIONES
  #############################################################################

  def llenar_formulario_data_table(tipo_usuario)
    #OBTENER DATOS DE CSV
    dt_row = get_data_by_filters("tipo_usuario = #{tipo_usuario.to_s.strip}", @dt_login)[0]
    puts "CSV DATA => dt_row => #{dt_row}"


    enter_text(@txt_usuario,dt_row[:usuario])
    enter_text(@txt_password,dt_row[:password])

  rescue Exception => e
    raise("Error => no se pudo llenar el formulario 'login'.
           \nException =>#{e.message}"
    )
  end

  def touch_boton_login
    #ocultar teclado
    hide_soft_keyboard
    #touch boton de login
    touch(@btn_login)

  rescue Exception => e
    raise("Error => al presionar en el boton 'INGRESAR'.
           \nException =>#{e.message}"
    )
  end

  #############################################################################
  # ASSERTS/VERIFYS/VALIDACIONES
  #############################################################################

  def assert_login_page_visible #
    wait_for_element_exists(
        @txt_usuario,
        {
            :timeout => 10,
            :timeout_message => "No se cargo la pagina de Login. \nElemento no encontrada #{@txt_usuario}",
        }
    )
  end

  def assert_alert_login_exitoso #
    wait_for_element_exists(
        @lbl_titulo_alert,
        {
            :timeout => 10,
            :timeout_message => "No se mostro el popup de Login exitoso",
        }
    )
  end

end


