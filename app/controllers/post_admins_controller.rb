class PostAdminsController < ApplicationController
  before_action :verify_admin, execpt: [:show]
  before_action :authenticate_user!, execpt: [:show]

  def index
    @posts = PostAdmin.all
  end

  def update
    post = PostAdmin.find_by id: params[:id]
    if post.update_attributes post_admin_params
        flash[:success] = "Update Successed"
        redirect_to post_admins_url
    else
        flash[:warning] = "Update Failed"
        redirect_to post_admins_url
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
      redirect_to post_admins_url
    else
      flash[:warning] = "Save Failed"
      redirect_to post_admins_url
    end
  end

  def show
    @post = PostAdmin.find_by id: params[:id]
    if @post.nil?
      flash[:warning] = "Not exist"
      redirect_to root_path
    end
  end

  def destroy
    @post = PostAdmin.find_by id: params[:id]
    if @post.destroy
      flash[:success] = "Destroy Successed"
      redirect_to post_admins_url
    else
      flash[:success] = "Destroy Successed"
      redirect_to post_admins_url
    end
  end

private

  def post_admin_params
    params.require(:post_admin).permit :body, :title
  end
end
