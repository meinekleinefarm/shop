# encoding: UTF-8
require 'spec_helper'
describe Spree::Order do
  
  subject do
    FactoryGirl.build(:order)
  end
  
  let :ship_address do
    FactoryGirl.create(:address)
  end

  let :bill_address do
    FactoryGirl.create(:address)
  end
  
  context :validations do
    
    it { should be_valid }
    
  end
  
  context :csv do
    it "should render csv" do
      subject.to_csv.should eql ""
    end
  end
end
