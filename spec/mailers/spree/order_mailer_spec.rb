# encoding: UTF-8
require 'spec_helper'
describe Spree::OrderMailer do

  let(:order) {
    FactoryGirl.create(:order,
      bill_address: FactoryGirl.create(:address),
      ship_address: FactoryGirl.create(:address),
      state: 'complete',
      completed_at: 1.day.ago
    )
  }
  context "confirmation mail" do

    let(:mail) { Spree::OrderMailer.confirm_email(order) }

    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should match 'MeineKleineFarm.org Es geht um die Wurst'
    end

    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [order.user.email]
    end

    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == ['shop@meinekleinefarm.org']
    end

    #ensure that mail is sent as text and html
    it "renders the body as text and html" do
      mail.body.encoded.should include("Content-Type: text/plain")
      mail.body.encoded.should include("Content-Type: text/html")
    end
  end
end