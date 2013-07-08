# encoding: UTF-8
require 'spec_helper'

describe Spree::User do

  subject { FactoryGirl.build(:user) }
  
  context :validations do
    
    it { should be_valid }
    
  end
end
