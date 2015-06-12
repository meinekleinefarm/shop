module Shopify
  class ArticleAdapter

    def self.markdown
      @@markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end

    def initialize(spree_post, blog)
      @spree_post = spree_post
      @blog       = blog
    end

    def to_shopify
      @article ||= ShopifyAPI::Article.new(
        author:       @spree_post.name,
        blog_id:      @blog.id,
        body_html:    self.class.markdown.render(@spree_post.body),
        published:    @spree_post.live,
        published_at: @spree_post.posted_at,
        title:        @spree_post.title,

        updated_at:   @spree_post.updated_at,
        created_at:   @spree_post.created_at
      )
    end
  end
end