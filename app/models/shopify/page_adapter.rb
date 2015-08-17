module Shopify
  class PageAdapter

    def self.markdown
      @@markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end

    def initialize(spree_page)
      @spree_page = spree_page
    end

    def to_shopify
      ShopifyAPI::Page.new(
        title:      @spree_page.title,
        body_html:  self.class.markdown.render(@spree_page.contents.first.body),
        handle:     @spree_page.path,
        created_at: @spree_page.created_at,
        updated_at: @spree_page.updated_at
      )
    end
  end
end