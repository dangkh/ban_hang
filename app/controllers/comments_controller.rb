class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :load_product
  skip_before_filter :verify_authenticity_token, only: [:create, :destroy]
  
  def create
    @comment = @product.comments.build comment_params
    @comment.user = current_user
    render partial: "comment", locals: {comment: @comment} if @comment.save
  end

  def destroy
    if current_user == @comment.user or current_user.admin?
      if @comment.destroy
        flash[:success] = t :success
      else
        flash[:danger] = t :error
      end
    else
      flash[:danger] = t :error
    end
  end

  private
  def comment_params
    params.require(:comment).permit :content
  end

  def load_product
    @product = Product.find_by id: params[:product_id]
    render_404 unless @product
  end
end
