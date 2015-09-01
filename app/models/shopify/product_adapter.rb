module Shopify
  class ProductAdapter

    def initialize(spree_product)
      @spree_product = spree_product
    end

    def attributes
      {
        product_id: @spree_product.id.to_s,
        sku: @spree_product.sku,
        title: @spree_product.name,
        body_html: @spree_product.description,
        price: @spree_product.price.to_f,
        weight: @spree_product.weight.to_i,
        handle: @spree_product.permalink,
        product_type: @spree_product.taxons.where(taxonomy_id: category.id).limit(1).pluck(:name).first,
        vendor: @spree_product.taxons.where(taxonomy_id: hof.id).limit(1).pluck(:name).first,
        requires_shipping: !giftcard?,
        inventory_management: 'shopify',
        published_at: @spree_product.available_on,
        images: images,
        options: [
          {
            name: "Tier"
          }
        ],
        variants: variants
      }
    end

    def to_shopify
      @product ||= ShopifyAPI::Product.new(attributes)
    end

    def giftcard?
      @spree_product.is_gift_card?
    end

    def images
      @images ||= @spree_product.images.map do |image|
        ImageAdapter.new(image).to_shopify
      end
    end

    def variants
      @variants ||= @spree_product.variants.map do |variant|
        VariantAdapter.new(variant).to_shopify
      end
    end

    # Spree::Product.all.each{|p|  Shopify::ProductAdapter.new(p).to_shopify.save }

    def hof
      Spree::Taxonomy.find_by_name('Hof')
    end

    def category
      Spree::Taxonomy.find_by_name('Art')
    end

  end
end