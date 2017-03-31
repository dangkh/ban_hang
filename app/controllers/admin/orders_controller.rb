class Admin::OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :verify_admin, :authenticate_user!

  def index
    params[:limit] = Settings.user.per_page
    @search = Order.search params[:q]
    @orders = @search.result.page(params[:page]).per params[:limit]
  end

  def edit
    @order_details = @order.order_details
    @products = get_product @order_details
    respond_to do |format|
      format.html{render partial: "list_order", locals: {order: @order,
        products: @products, order_details: @order_details}}
    end
  end

  def update
    if params[:status].present?
      unless params[:status] == Settings.success
        if @order.update_attributes status: params[:status]
          flash[:success] = t :update_success
        else
          flash[:notice] = t :update_fail
        end
      else
        if @order.update_attributes status: :success
          user = User.find_by id: @order.user_id
          SendOrderMailer.send_order(user, @order).deliver_now
          message_body = Order.load_info_to_chatwork @order
          ChatWork::Message.create room_id: ENV["chatwork_room_id"],
            body: message_body
          flash[:success] = t :success_order
        else
          @order.update_attributes status: :delay
          flash[:notice] = t :not_enough_product_in_stock
        end
      end
    end
    redirect_to admin_orders_path
  end

  private
  def get_product order_details
    products = []
    order_details.each do |order_detail|
      products.push(order_detail.product)
    end
    return products
  end
end
