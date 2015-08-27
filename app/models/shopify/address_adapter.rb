module Shopify
  class AddressAdapter

    def initialize(spree_address)
      @spree_address = spree_address
    end

    def to_shopify
      return nil unless @spree_address.present?
      @address ||= ShopifyAPI::Address.new(
        first_name: @spree_address.firstname,
        last_name:  @spree_address.lastname,
        company:    @spree_address.company,
        address1:   @spree_address.address1,
        address2:   @spree_address.address2,
        city:       @spree_address.city,
        zip:        @spree_address.zipcode,
        phone:      @spree_address.phone,
        country:    @spree_address.country.iso
      )
      @address
    end
  end
end