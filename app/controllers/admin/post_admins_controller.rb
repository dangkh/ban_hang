class Admin::PostAdminsController < ApplicationController
  load_and_authorize_resource
  before_action :verify_admin, :authenticate_user!

  def index
  end

  def new
  end

  def create
    tmp = PostAdmin.new post_admin_params
    redirect_to root_path
  end

  def show
  end

private

  def post_admin_params
    params.require(:post_admin).permit :body, :title
  end
end
