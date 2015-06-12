module Shopify
  class BlogAdapter

    def initialize(spree_blog)
      @spree_blog = spree_blog
    end

    def to_shopify
      @blog ||= ShopifyAPI::Blog.new(
        title:        @spree_blog.name,
        handle:       @spree_blog.permalink,
        updated_at:   @spree_blog.updated_at,
        created_at:   @spree_blog.created_at
      )
    end
  end
end