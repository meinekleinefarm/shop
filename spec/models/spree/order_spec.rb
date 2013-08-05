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
      5.times do |i|
        FactoryGirl.create(:line_item, :order => subject)
      end
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
        subject.id.to_s,
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
        "0.0",
        "0.0",
        "0.0",
        "",
        "0.0",
        "0.0",
        "0.0",
        subject.created_at.strftime("%Y-%m-%d"),
        subject.created_at.strftime("%H:%M:%S"),
        subject.updated_at.strftime("%Y-%m-%d"),
        subject.updated_at.strftime("%H:%M:%S"),
        "ProduktID: 3 Rotwurst (Schwein 1) 1 Glas / 200g 1 x 3,50 EUR = 3,50 EUR ----------------------------- ProduktID: 4 Sülze (Schwein 1) 1 Glas / 200g 2 x 3,50 EUR = 7,00 EUR ----------------------------- Zwischensumme: 10,50 EUR Verpackungs- und Lieferkosten: 5,90 EUR ----------------------------- Gesamt: 16,40 EUR ----------------------------- -----------------------------   Gemäß § 19 Umsatzsteuergesetz erheben wir als Kleinunternehmen keine Umsatzsteuer."
      ]
    end
  end
end
