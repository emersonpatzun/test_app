# encoding: utf-8

Feature: LOGIN
  - As a valid user you must be able to login
  - As an invalid user I must not be able to login
  - I must not be able to login with invalid credentials

  @regresion @login_01
  Scenario: login_01 - LOGIN SUCCESSFUL
    Given I open the application
    Then the 'Login' page is displayed
    When I login as "valid user"
    Then The 'Login Successful' popup is displayed

