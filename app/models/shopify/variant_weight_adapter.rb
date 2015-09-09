module Shopify
  class VariantWeightAdapter

    def initialize(spree_variant)
      @spree_variant = spree_variant
    end

    def attributes
      {
        grams: grams,
        weight_unit: 'g',
        inventory_quantity: @spree_variant.count_on_hand,
        title: title,
        option1: weight_option,
        option2: animal_option,
        price: @spree_variant.price.to_f,
        sku: sku,
        barcode: barcode,
        product_id: @spree_variant.product.id.to_s,
        inventory_management: 'shopify',
      }
    end

    def to_shopify
      @variant ||= ShopifyAPI::Variant.new(attributes)
    end

    def grams
      @spree_variant.weight.to_i
    end

    def sku
      [@spree_variant.sku, grams].compact.join('-')
    end

    def animal_option
      @spree_variant.option_values.try(:first).try(:name)
    end

    def weight_option
      "#{grams} g"
    end

    def title
      [animal_option,weight_option].join(' / ')
    end

    def barcode
      sp = Spree::Property.find_by_name('ean')
      sp.product_properties.where(product_id: @spree_variant.product.id).first.try(:value)
    end
  end
end