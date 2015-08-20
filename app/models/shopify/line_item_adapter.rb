module Shopify
  class LineItemAdapter

    def initialize(spree_item)
      @spree_item = spree_item
    end

    def to_shopify
      @line_item ||= ShopifyAPI::LineItem.new(
        variant_id: @spree_item.variant.id,
        quantity:   @spree_item.quantity,
        price:      @spree_item.price,
        title:      @spree_item.variant.name,
        name:       @spree_item.variant.name,
        grams:      @spree_item.variant.weight
      )
    end
  end
end
