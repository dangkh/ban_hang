class ViewController < ApplicationController
  def index
    @products = Product.load_product_by_id(" ", session[:viewed])
      .take Settings.viewed.number_product
  end
end
