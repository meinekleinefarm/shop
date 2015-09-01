module Shopify
  class VariantAdapter

    def initialize(spree_variant)
      @spree_variant = spree_variant
    end

    def to_shopify
      @variant ||= ShopifyAPI::Variant.new(
      grams: @spree_variant.weight.to_i,
      weight_unit: 'g',
      inventory_quantity: @spree_variant.count_on_hand,
      title: @spree_variant.option_values.first.name,
      option1: option1,
      price: @spree_variant.price.to_f,
      sku: @spree_variant.sku,
      barcode: barcode,
      product_id: @spree_variant.product.id.to_s,
      inventory_management: 'shopify',
      )
    end

    def option1
      @spree_variant.
      option_values.
      joins(:option_type).
      order("#{Spree::OptionType.table_name}.position asc").
      first.try(:presentation)
    end

    def barcode
      sp = Spree::Property.find_by_name('ean')
      sp.product_properties.where(product_id: @spree_variant.product.id).first.try(:value)
    end
  end
end