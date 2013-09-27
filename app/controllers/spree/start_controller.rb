class Spree::StartController < Spree::StoreController
  helper "spree/products"
  helper "spree/base"

  respond_to :html

  def index
    @schweine = Spree::Schwein.order('position ASC').limit(3)
    @searcher = Spree::Config.searcher_class.new({per_page:3})
    @products = @searcher.retrieve_products[0...3]
  end

end
