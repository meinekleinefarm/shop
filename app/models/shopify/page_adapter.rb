module Shopify
  class PageAdapter

    def initialize(spree_page)
      @spree_page = spree_page
    end

    def to_shopify
      ShopifyAPI::Page.new(
      id:       @spree_page.id,
      title:    @spree_page.title,
      body_html:
      handle:   @spree_page.path
      published_at:

      created_at: @spree_page.created_at
      updated_at: @spree_page.updated_at
      )
    end
  end
end