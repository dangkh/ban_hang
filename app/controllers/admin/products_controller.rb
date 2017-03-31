class Admin::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  load_and_authorize_resource
  before_action :authenticate_user!, :verify_admin, :load_category
  before_action :load_product, only: [:update, :destroy]

  def index
    @products = Product.search params[:search], @category.id
    @products = Kaminari.paginate_array(@products)
      .page(params[:page]).per Settings.product.per_page
  end

  def show
    @product = Product.get_product_by_category params[:id], @category
    if @product.nil?
      flash[:danger] = t :not_exist_data
      redirect_to home_url
    end
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = @category.products.new product_params
    hot = params[:hot].nil? ? false : true
    @product.update_attributes is_hot: hot
    if @product.save
      flash[:success] = t :create_success
      redirect_to admin_category_products_url category_id: @category.id
    else
      flash[:warning] = t :create_fail
      redirect_to :back
    end
  end

  def update
    hot = params[:hot].nil? ? false : true
    @product.update_attributes is_hot: hot
    if @product.update_attributes product_params
      flash[:success] = t :update_success
      redirect_to admin_category_products_url category_id: @category.id
    else
      flash[:warning] = t :update_fail
      redirect_to :back
    end
  end

  def destroy
    @product.order_details.empty? ? @product.destroy :
      render(status: Settings.error_number)
  end

  def import
    Product.import params[:file]
    redirect_to :back
  end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    if @product.nil?
      flash[:danger] = t :not_exist_data
      redirect_to root_url
    end
  end

  def product_params
    params.require(:product).permit :name, :description, :image, :price, :in_stock
  end
end
