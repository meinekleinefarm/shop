# encoding: UTF-8
require 'spec_helper'

describe Spree::User do

  subject { FactoryGirl.build(:user) }

  describe :validations do

    it { expect(subject).to be_valid }

  end

  describe :callbacks do

    it "makes sure admins have authentication token" do
      subject =  FactoryGirl.create(:admin_user)

      expect(subject).to be_admin
      expect(subject).to receive(:ensure_authentication_token)
      subject.save
    end

    it "doesn't care for normal users and authentication token" do
      expect(subject).not_to be_admin
      expect(subject).not_to receive(:ensure_authentication_token)
      subject.save
    end

  end

end
