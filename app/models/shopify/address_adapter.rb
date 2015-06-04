module Shopify
  class AddressAdapter

    def initialize(spree_address)
      @spree_address = spree_address
    end

    def to_shopify
      @address ||= ShopifyAPI::Address.new(
        address1:   @spree_address.address1,
        city:       @spree_address.city,
        phone:      @spree_address.phone,
        zip:        @spree_address.zipcode,
        last_name:  @spree_address.lastname,
        first_name: @spree_address.firstname,
        country:    @spree_address.country.iso
      )
    end
  end
end