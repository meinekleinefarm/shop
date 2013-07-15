# encoding: UTF-8
require 'spec_helper'
describe Spree::Address do

  subject do
    FactoryGirl.create(:address)
  end

  it "should be valid and ready to safe." do
    subject.save!
  end
end