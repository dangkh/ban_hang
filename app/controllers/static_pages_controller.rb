class StaticPagesController < ApplicationController
  def home
    @products = Product.take_home_product
  end

  def about
  end

  def index
    @products = Product.search_home params[:search]
    @products = Kaminari.paginate_array(@products)
      .page(params[:page]).per Settings.product.per_page_home
  end

  def news
    @posts = PostAdmin.all
    @hot_posts = PostAdmin.all.take(2)
  end
end
