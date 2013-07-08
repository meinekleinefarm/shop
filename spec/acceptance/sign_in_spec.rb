require 'spec_helper'

feature "Sign in", %q{
  In order to check my order status
  As a customer
  I want to sign in
} do
 
  background do
    FactoryGirl.create(:admin, email: "admin@example.com", password: "secret_password", password_confirmation: "secret_password")
  end

  scenario "Sign in" do
    visit '/admin'
    fill_in "E-Mail", with: "admin@example.com"
    fill_in "Passwort", with: "secret_password"
    click_button "Login"
  end

end