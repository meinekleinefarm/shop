# encoding: UTF-8
require 'spec_helper'
describe Spree::Order do
  subject { FactoryGirl.build(:spree_order) }
  
  context :validations do
    
    it { should be_valid }
  end
end
