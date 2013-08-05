require 'spec_helper'

feature "Order a Wurst", %q{
  In order to get some nice foord
  As a customer
  I want to order it to my door
} do

  background do
    FactoryGirl.create(:product)
  end

  scenario "Sign in" do
    visit '/'
  end

end