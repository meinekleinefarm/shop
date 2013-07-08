# encoding: UTF-8
require 'spec_helper'
describe Spree::Product do
  subject { FactoryGirl.build(:product) }
  
  context :validations do
    
    it { should be_valid }
  end
end
