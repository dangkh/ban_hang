class Admin::UsersController < ApplicationController
  load_and_authorize_resource
  before_action :verify_admin, :authenticate_user!

  def index
    params[:limit] = Settings.user.per_page
    @users = User.includes(:orders)
      .select(:id, :name, :email, :address).page(params[:page])
      .per params[:limit]
  end

  def destroy
    if @user.orders.any? or @user.suggest_products.any?
      flash[:danger] = t :views_admin_users_index_exist
    else
      if @user.destroy
        flash[:success] = t :delete_successful
      else
        flash[:danger] = t :delete_fail
      end
    end
    redirect_to admin_users_path
  end
end
