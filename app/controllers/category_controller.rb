class CategoryController < ApplicationController
  before_action :load_category, only: [:show]

  def index
    @categories = Category.select{|cate| cate.parent_id == Settings.category_id.parent}
  end

  def show
    @categories = Category.get_child @category.id
  end

  private
  def load_category
    @category = Category.find_by id: params[:id]
    if @category.nil?
      flash[:danger] = t :not_exist_data
      redirect_to home_path
    end
  end
end
