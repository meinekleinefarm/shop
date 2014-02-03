# encoding: utf-8
Spree::User.class_eval do

  before_save :ensure_admin_authentication_token

  private

  def ensure_admin_authentication_token
    ensure_authentication_token if admin?
  end
end
