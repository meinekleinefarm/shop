module Shopify
  class ProductWeightAdapter < ProductAdapter

    def initialize(spree_product, name)
      @spree_product = spree_product
      @name = name
    end

    def attributes
      {
        product_id: @spree_product.id.to_s,
        sku: @spree_product.sku,
        title: name,
        body_html: @spree_product.description,
        price: @spree_product.price.to_f,
        weight: @spree_product.weight.to_i,
        handle: handle,
        product_type: @spree_product.taxons.where(taxonomy_id: category.id).limit(1).pluck(:name).first,
        vendor: @spree_product.taxons.where(taxonomy_id: hof.id).limit(1).pluck(:name).first,
        requires_shipping: !giftcard?,
        inventory_management: 'shopify',
        published_at: @spree_product.available_on,
        images: images,
        options: options,
      }
    end

    def options
      [
        { name: "Gewicht" },
        { name: "Tier" }
      ]
    end

    def name
      @name
    end

    def handle
      @name.parameterize
    end

  end
end