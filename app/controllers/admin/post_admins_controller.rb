class Admin::PostAdminsController < ApplicationController
  load_and_authorize_resource
  before_action :verify_admin, :authenticate_user!

  def index
    @posts = PostAdmin.all
  end

  def new
  end

  def create
    tmp = PostAdmin.new post_admin_params
    if tmp.save
      flash[:success] = "Save Successed"
      redirect_to admin_post_admins_url
    else
      flash[:warning] = "Save Failed"
      redirect_to admin_post_admins_url
    end
  end

  def show
    @post = PostAdmin.find_by id: params[:id]
  end

private

  def post_admin_params
    params.require(:post_admin).permit :body, :title
  end
end
