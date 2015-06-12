require 'forgery'
module Shopify
  class ImageAdapter

    def initialize(spree_image)
      @spree_image = spree_image
    end

    def to_shopify
      @image ||= ShopifyAPI::Image.new(
        src: "http://www.meinekleinefarm.org#{@spree_image.attachment.url(:original)}"
      )
    end
  end
end