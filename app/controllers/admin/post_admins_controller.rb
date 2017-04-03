class Admin::PostAdminsController < ApplicationController
  load_and_authorize_resource
  before_action :verify_admin, :authenticate_user!

  def index
  end

  def new
  end

  def create
  end

  def show
  end

end
