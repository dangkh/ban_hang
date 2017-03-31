class ProductsController < ApplicationController
  before_action :load_category, only: [:index, :show]
  helper_method :sort_column, :sort_direction

  def index
    @products = Product.search(params[:search], @category.id)
      .order sort_column + " " + sort_direction
    @products = Kaminari.paginate_array(@products)
      .page(params[:page]).per Settings.product.per_page
  end

  def show
    @product = Product.get_product_by_category params[:id], @category
    if @product.nil?
      flash[:danger] = t :not_exist_data
      redirect_to home_path
    else
      @supports = Supports::Product.new @product, current_user
      if session[:viewed].present?
        session[:viewed] = session[:viewed].append @product.id
      else
        session[:viewed] = [@product.id]
      end
      @comments = @product.comments.order created_at: :DESC
    end
  end

  private

  def sort_column
    Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    ["asc", "desc"].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
