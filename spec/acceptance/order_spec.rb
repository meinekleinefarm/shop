require 'spec_helper'

feature "Order a Wurst", %q{
  In order to get some nice food
  As a customer
  I want to order it to my door
} do

  background do
    @usa              = FactoryGirl.create(:country, iso_name: "UNITED STATES", name: "United States", iso3: "USA", iso: "US")
    @germany          = FactoryGirl.create(:country, iso_name: "GERMANY",       name: "Deutschland",   iso3: "DEU", iso: "DE")
    @global           = FactoryGirl.create(:global_zone, default_tax: true)
    expect(@global.default_tax).to be_true
    expect(@global.members.map(&:zoneable)).to include(@germany)

    @shipping_method  = FactoryGirl.create(:shipping_method_with_category)
    @shipping_category = @shipping_method.shipping_category
    @shipping_category.shipping_methods.each do |method|
      expect(method.zone).to eql @global
    end

    @tax_category     = FactoryGirl.create(:tax_category_with_rates, is_default: true)
    @tax_category.tax_rates.each do |rate|
      expect(rate.zone).to eql @global
    end

    @product          = FactoryGirl.create(:product, price: 10.00, tax_category: @tax_category, shipping_category: @shipping_category)
    expect(@product.shipping_category).to eql @shipping_category
    expect(@product.tax_category).to eql @tax_category

    @user             = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
  end

#  scenario "Signed in" do
#    visit '/'
#    expect(page).to have_content('Mein Konto')
#  end
#
#  scenario "Product page" do
#    visit '/'
#    click_link @product.name
#    expect(page.find('h1.product-title')).to have_content(@product.name)
#    expect(current_path).to eql "/products/#{@product.permalink}"
#  end
#
#  scenario "Product to cart" do
#    visit '/'
#    click_link @product.name
#    click_button '+ Warenkorb'
#    expect(current_path).to eql '/cart'
#  end
#
#  scenario "Checkout start" do
#    visit '/'
#    click_link @product.name
#    click_button '+ Warenkorb'
#    click_button 'Zur Kasse'
#    expect(current_path).to eql '/checkout/address'
#  end

  scenario "Checkout step two: Address" do
    visit '/'
    click_link @product.name
    click_button '+ Warenkorb'
    click_button 'Zur Kasse'
#    expect(Spree::Order.last.a  vailable_shipping_methods).not_to be_empty
    within(:billing, '#billing') do
      fill_in 'Vorname',    with: 'Chris'
      fill_in 'Nachname',   with: 'Tucker'
      fill_in 'Adresse',    with: '1234 Hollywood Blv.'
      fill_in 'Stadt',      with: 'Los Angeles'
      fill_in 'PLZ',        with: '90210'
      select 'Deutschland', from: 'Land'
    end

    within(:shipping, '#shipping') do
      check 'Rechnungsadresse verwenden'
    end
    click_button 'Speichern und fortsetzen'
    save_and_open_page
    expect(current_path).to eql '/checkout/delivery'
  end

end