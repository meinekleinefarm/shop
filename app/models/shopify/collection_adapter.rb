require 'forgery'
module Shopify
  class CollectionAdapter

    def initialize(spree_taxon)
      @spree_taxon = spree_taxon
    end

    def to_shopify
    end
  end
end