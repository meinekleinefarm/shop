module Shopify
  class LineItemAdapter

    def initialize(spree_item)
      @spree_item = spree_item
    end

    def to_shopify
      @line_item ||= ShopifyAPI::LineItem.new(
        variant_id: @spree_item.variant.id,
        variant_title: @spree_item.variant.id,
        quantity:   @spree_item.quantity,
        price:      @spree_item.price,
        sku:        @spree_item.variant.sku,
        title:      @spree_item.variant.product.name,
        name:       @spree_item.variant.name,
        grams:      @spree_item.variant.weight,
        gift_card:  giftcard?,
        requires_shipping: requires_shipping,

      )
    end

    def requires_shipping
      !giftcard?
    end


    def giftcard?
      @spree_item.variant.product.is_gift_card?
    end

    def variant_title
      @spree_item.variant.
      option_values.
      joins(:option_type).
      order("#{Spree::OptionType.table_name}.position asc").
      first.presentation
    end
  end
end
