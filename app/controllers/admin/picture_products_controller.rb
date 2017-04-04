class Admin::PictureProductsController < ApplicationController
  before_action :verify_admin, :authenticate_user!

  def new
    @product = Product.find_by id: params[:id]
    @picture_product = PictureProduct.new
  end

  def create
    @product = Product.find_by id: params[:picture_product][:product_id]
    @picture = @product.picture_products.new picture_product_params
    if @picture.save
      flash[:success] = t :create_success
      redirect_to edit_admin_category_product_url category_id: @product.category_id, id: @product.id
    else
      flash[:warning] = t :create_fail
      redirect_to edit_admin_category_product_url category_id: @product.category_id, id: @product.id
    end
  end

  def destroy
  end

  def index
    @picture = PictureProduct.find_by product_id: params[:id]
  end

  private
  def picture_product_params
    params.require(:picture_product).permit :image
  end
end
