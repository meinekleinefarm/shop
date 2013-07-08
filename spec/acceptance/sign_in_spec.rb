require 'spec_helper'

feature "Sign in", %q{
  In order to check my order status
  As a customer
  I want to sign in
} do

  background do
    FactoryGirl.create(:spree_order)
  end

  scenario "Sign in" do
    visit '/'
    page.should have_content('Two')
  end

end