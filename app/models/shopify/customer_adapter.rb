require 'forgery'
module Shopify
  class CustomerAdapter

    def initialize(spree_user)
      @spree_user = spree_user
    end

    def to_shopify
      @customer ||= ShopifyAPI::Customer.new(
        accepts_marketing:      @spree_user.subscribed?,
        created_at:             @spree_user.created_at,
        updated_at:             @spree_user.updated_at,
        email:                  @spree_user.email,
        verified_email:         true,
        customer_id:            @spree_user.id,
        orders_count:           @spree_user.orders.count,
        password:               password,
        password_confirmation:  password,
        send_email_welcome:     false,
        addresses:              addresses,
        )
    end

    def password
      @password ||= Forgery(:basic).password(at_least: 32, at_most: 32)
    end

    def addresses
      @spree_user.addresses.map do |address|
        AddressAdapter.new(address).to_shopify
      end
    end
  end
end