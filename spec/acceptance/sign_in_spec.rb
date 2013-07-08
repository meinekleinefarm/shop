require 'spec_helper'

feature "Sign in", %q{
  In order to check my order status
  As a customer
  I want to sign in
} do

  background do
    FactoryGirl.create(:order)
  end

  scenario "Sign in" do
    visit '/'
  end

end