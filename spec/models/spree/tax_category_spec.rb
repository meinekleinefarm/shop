# encoding: UTF-8
require 'spec_helper'

describe Spree::TaxCategory do

  subject { FactoryGirl.build(:tax_category) }

  describe "associations" do

    it { expect(subject).to have_many(:products).dependent(:nullify) }
  end
end