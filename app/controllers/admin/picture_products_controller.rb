class Admin::PictureProductsController < ApplicationController
  before_action :verify_admin, :authenticate_user!
  skip_before_action :verify_authenticity_token

  def new
    @product = Product.find_by id: params[:product_id]
    @category = @product.category
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
    @picture = PictureProduct.find_by id: params[:id]
    @picture.destroy
  end

  def index
    @pictures = PictureProduct.select{|pic| pic.product_id == params[:product_id]}
  end

  private
  def picture_product_params
    params.require(:picture_product).permit :image
  end
end
