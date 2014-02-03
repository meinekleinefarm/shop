require 'spec_helper'

feature "Sign in", %q{
  In order to check work
  As a admin
  I want to sign in
} do

  background do
    FactoryGirl.create(:admin_user, email: "admin@example.com", password: "secret_password", password_confirmation: "secret_password")
  end

  scenario "Sign in" do
    visit '/admin'
    fill_in "E-Mail", with: "admin@example.com"
    fill_in "Passwort", with: "secret_password"
    click_button "Login"
    expect(page.find('.flash')).to have_content('Anmeldung erfolgreich')
  end

end

feature "Sign in", %q{
  In order to order wurst
  As a user
  I want to sign in
} do

  background do
    FactoryGirl.create(:user, email: "user1@example.com", password: "secret_password", password_confirmation: "secret_password")
  end

  scenario "Sign in" do
    visit '/admin'
    fill_in "E-Mail", with: "user1@example.com"
    fill_in "Passwort", with: "secret_password"
    click_button "Login"
    expect(page.find('.flash')).to have_content('Anmeldung erfolgreich')
  end

end