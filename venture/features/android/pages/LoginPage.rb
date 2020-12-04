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
    @txt_user = "android.widget.EditText id:'txtUsuario'"
    @txt_password = "android.widget.EditText id:'txtPassword'"
    @btn_login = "android.widget.Button id:'btnLogin'"
    @lbl_alert_title = "* id:'alertTitle'"
    @btn_accept_alert = "* text:'Aceptar'"
  end

  #############################################################################
  # ACTIONS
  #############################################################################
  #
  def fill_data_table_form(user_type)
    #GET DATA FROM CSV
    dt_row = get_data_by_filters("user_type = #{user_type.to_s.strip}", @dt_login)[0]
    puts "CSV DATA => dt_row => #{dt_row}"

    enter_text(@txt_user,dt_row[:user])
    enter_text(@txt_password,dt_row[:password])

  rescue Exception => e
    raise("Error => the 'login' form could not be filled .
           \nException =>#{e.message}"
    )
  end

  def touch_button_login
    #hide keyboard
    hide_soft_keyboard
    #touch login button
    touch(@btn_login)

  rescue Exception => e
    raise("Error => by pressing on the 'ENTER' button.
           \nException =>#{e.message}"
    )
  end

  #############################################################################
  # ASSERTS/VERIFIES/VALIDATIONS
  #############################################################################

  def assert_login_page_visible
    wait_for_element_exists(
        @txt_user,
        {
            :timeout => 10,
            :timeout_message => "The login page did not load. \nItem not found #{@txt_user}",
        }
    )
  end

  def assert_alert_login_successful
    wait_for_element_exists(
        @lbl_alert_title,
        {
            :timeout => 10,
            :timeout_message => "Successful Login popup was not displayed",
        }
    )
  end

end


