# language: es
# encoding: utf-8
Característica: LOGIN
  - Como usario valido debo poder hacer login
  - Como usuario invalido no debo poder hacer login
  - No debo poder hacer login con credenciales invalidas

  @regresion @login_01
  Escenario: login_01 - LOGIN EXITOSO
    Dado Abro la aplicacion
    Entonces Se muestra la pagina de 'Login'
    Cuando Hago login como "usuario valido"
    Entonces Se muestra el popup de 'Login exitoso'
