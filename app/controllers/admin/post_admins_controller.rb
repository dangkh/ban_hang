class Admin::PostAdminsController < ApplicationController
  load_and_authorize_resource
  before_action :verify_admin, :authenticate_user!

  def index
    @posts = PostAdmin.all
  end

  def update
    post = PostAdmin.find_by id: params[:id]
    if post.update_attributes post_admin_params
        flash[:success] = "Update Successed"
        redirect_to admin_post_admins_url
    else
        flash[:warning] = "Update Failed"
        redirect_to admin_post_admins_url
    end
  end

  def edit
    @post_admin = PostAdmin.find_by id: params[:id]
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
