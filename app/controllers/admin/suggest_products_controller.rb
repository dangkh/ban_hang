class Admin::SuggestProductsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, :verify_admin

  def index
    params[:limit] = Settings.user.per_page
    @search = SuggestProduct.search params[:q]
    @suggest_products = @search.result.includes(:user, :category)
      .page(params[:page]).per params[:limit]
  end

  def update
    if params[:accept]
      if @suggest_product.present?
        @suggest_product.update_attributes status: :accept
        if @suggest_product.add_product_from_suggest
          flash[:success] = t :accept_and_add_to_product
        else
          flash[:notice] = t :accept_but_dont_add_to_product
        end
      else
        flash[:notice] = t :accept_fail
      end
    else
      if @suggest_product.update_attributes status: :cancel
        flash[:success] = t :cancel
      else
        flash[:notice] = t :accept_fail
      end
    end
    redirect_to :back
  end
end
