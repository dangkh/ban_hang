class RatingsController < ApplicationController
  before_action :check_role_current_user
  skip_before_action :verify_authenticity_token
  include ApplicationHelper

  def create
    current_user.ratings.create rate: params[:rate],
      user_id: current_user.id, product_id: params[:product_id]
    redirect_to :back
  end

  def update
    respond_to do |format|
      @rate = Rating.find_by id: params[:id]
      @rate.update_attributes rate: params[:rate]
    end
  end
end
