# encoding: UTF-8
require 'spec_helper'
describe Spree::Order do

  subject do
    FactoryGirl.build(:order)
  end

  context :validations do

    it { should be_valid }

  end

  context :new_order do

    subject do
      FactoryGirl.build(:new_order)
    end

    it "should render csv" do
      subject.to_csv.should eql ""
    end
  end

  context :completed_order do
    subject do
      FactoryGirl.build(:completed_order)
    end

    it "should render csv" do
      subject.to_csv.should eql ""
    end
  end
end
