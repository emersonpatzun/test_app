# encoding: utf-8
require 'fileutils'
require 'calabash-android/abase'

class GenericPage < Calabash::ABase

  #############################################################################
  # MOBILE ELEMENTS
  #############################################################################
  def initialize(world)
    super(world)
  end

  #############################################################################
  # ACCIONES
  #############################################################################

  def abrir_app
    true
  end

  #############################################################################
  # ASSERTS/VERIFYS/VALIDACIONES
  #############################################################################

end