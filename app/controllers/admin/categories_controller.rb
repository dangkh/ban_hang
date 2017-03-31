class Admin::CategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :verify_admin, :authenticate_user!

  def index
    params[:limit] = Settings.user.per_page
    @search = Category.search params[:q]
    @categories = @search.result.page(params[:page]).per params[:limit]
  end

  def edit
    respond_to do |format|
      format.html{render partial: "create_form", locals: {category: @category}}
    end
  end

  def create
    @category = Category.new name: params[:name], description: params[:description]
    if @category.update parent_id: params[:parent_id].to_i
      flash[:success] = t :views_admin_categories_index_create_success
    else
      flash[:notice] = t :views_admin_categories_index_create_fail
    end
    redirect_to :back
  end

  def update
    if @category.update_attributes name: params[:category][:name], description: params[:category][:description]
      flash[:success] = t :views_admin_categories_index_update_success
    else
      flash[:notice] = t :views_admin_categories_index_update_fail
    end
    redirect_to admin_categories_path
  end

  def destroy
    if @category.products.any? and Category.get_child(@category.id).any?
      flash[:danger] = t :views_admin_categories_index_exist
    else
      if @category.destroy
        flash[:success] = t :views_admin_categories_index_delete_success
      else
        flash[:danger] = t :views_admin_categories_index_delete_fail
      end
    end
    redirect_to admin_categories_path
  end
end
