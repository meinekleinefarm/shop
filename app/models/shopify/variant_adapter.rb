module Shopify
  class VariantAdapter

    def initialize(spree_variant)
      @spree_variant = spree_variant
    end

    def to_shopify
      @variant ||= ShopifyAPI::Variant.new(
      grams: @spree_variant.weight,
      weight_unit: 'g',
      inventory_quantity: @spree_variant.count_on_hand,
      title: @spree_variant.option_values.first.name,
      option1: @spree_variant.option_values.first.name,
      price: @spree_variant.price,
      sku: @spree_variant.sku,
      inventory_management: 'shopify',
      images: images
      )
    end

    def images
      @images ||= @spree_variant.images.map do |image|
        ImageAdapter.new(image).to_shopify
      end

    end
  end
end