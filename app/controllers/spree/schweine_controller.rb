class Spree::SchweineController < Spree::StoreController
  helper "spree/products"
  helper "spree/base"

  respond_to :html

  def index
    @schweine = Spree::Schwein.page(params[:page])
  end

  def show
  end

end
