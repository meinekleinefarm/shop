# encoding: UTF-8
require 'spec_helper'
describe Spree::Order do

  let :bill_address do
    FactoryGirl.create(:address)
  end

  let :ship_address do
    FactoryGirl.create(:address)
  end

  subject do
    FactoryGirl.build(:order, :total => 120.0, bill_address: bill_address, ship_address: ship_address)
  end

  context :validations do

    it { should be_valid }

  end

  context :completed_order do

    before :each do
      subject.save!
      FactoryGirl.create(:line_item, :order => subject)
    end

    #{
    # id
    # status
    # billing_salutation
    # billing_first_name
    # billing_last_name
    # billing_zip
    # billing_city
    # billing_street
    # billing_street_nr
    # billing_email
    # billing_phone
    # shipping_salutation
    # shipping_first_name
    # shipping_last_name
    # shipping_zip
    # shipping_city
    # shipping_street
    # shipping_street_nr
    # shipping_email
    # shipping_phone
    # shipping_address_is_billing_address
    # is_gift
    # newsletter_subscription
    # price_products_total_with_tax
    # price_products_total_without_tax
    # price_products_total_tax
    # price_shipping_total
    # price_total
    # weight_total_in_gram
    # weight_total_in_gram_brutto
    # created_at_date
    # created_at_time
    # updated_at_date
    # updated_at_time
    # cart_text
    # comment
    #}

    it "should render csv" do
      subject.to_csv.should eql [
        "1",
        nil,
        "Herr/Frau",
        "John",
        "Doe",
        "20170",
        "Herndon",
        "10 Lovely Street",
        nil,
        "#{subject.email}",
        "123-456-7890",
        "Herr/Frau",
        "John",
        "Doe",
        "Herndon",
        "10 Lovely Street",
        nil,
        "#{subject.email}",
        "123-456-7890",
        "Nein",
        "Nein",
        "Nein",
        "0.0"
      ]
    end
  end
end
