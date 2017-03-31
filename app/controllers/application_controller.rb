class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_homepage_product, :load_category_menu

  rescue_from CanCan::AccessDenied do
    redirect_to root_path
  end

  def verify_admin
    unless current_user.present? and current_user.admin?
      redirect_to root_path
    end
  end

  private
  def load_category
    @category = Category.find_by id: params[:category_id]
    if @category.nil?
      flash[:danger] = t :not_exist_data
      redirect_to home_path
    end
  end

  def load_homepage_product
    @randomize = Product.take_random_product
    @news = Product.take_new_product
  end

  def load_category_menu
    @parent_category = Category.where("parent_id = ?", Settings.category_id.parent)
      .limit Settings.menu.ancestor_number
    @child_category = Array.new
    @parent_category.each do |category|
      @list_category = Category.where("parent_id = ?", category.id)
        .limit Settings.menu.child_number
      @child_category.append @list_category
    end
  end
end
