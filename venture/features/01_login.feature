# encoding: utf-8

Feature: LOGIN
  - As a valid user you must be able to login
  - As an invalid user I must not be able to login
  - I must not be able to login with invalid credentials

  @regresion @login_01
  Scenario: login_01 - LOGIN SUCCESSFUL
    Given I open the application
    Then The 'Login' page is displayed
    When I login as "valid user"
    Then The 'Login Successful' popup is displayed

  @regresion @Login_02
  Scenario: login_02 - LOGIN WITH WRONG USER
    Given I open the application
    Then The 'Login' page is displayed
    When I login as "invalid user"
    Then The 'Incorrect Login' popup is displayed

  @regresion @Login_03
  Scenario: Login_03 - LOGIN WITH INCORRECT PASSWORD
    Given I open the application
    Then The 'Login' page is displayed
    When I login as "wrong password"
    Then The 'Incorrect Login' popup is displayed
