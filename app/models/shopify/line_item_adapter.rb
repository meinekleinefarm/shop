module Shopify
  class LineItemAdapter

    def initialize(spree_item)
      @spree_item = spree_item
    end

    def to_shopify
      @line_item ||= ShopifyAPI::LineItem.new(
        product_id: @spree_item.product.id.to_s,
        title:      @spree_item.product.name,
        variant_id: @spree_item.variant.id.to_s,
        variant_title: variant_title,
        quantity:   @spree_item.quantity,
        price:      @spree_item.price,
        sku:        @spree_item.variant.sku,
        name:       @spree_item.variant.name,
        grams:      @spree_item.variant.weight.to_i,
        gift_card:  giftcard?,
        requires_shipping: !giftcard?,
      )
    end

    def giftcard?
      @spree_item.variant.product.is_gift_card?
    end

    def variant_title
      @spree_item.variant.
      option_values.
      joins(:option_type).
      order("#{Spree::OptionType.table_name}.position asc").
      first.try(:presentation)
    end
  end
end
