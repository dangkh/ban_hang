class Users::OrdersController < ApplicationController
  before_action :check_current_user

  def index
    @orders = current_user.orders.order :created_at
    @orders = Kaminari.paginate_array(@orders)
      .page(params[:page]).per Settings.order.per_page
    @total_price = current_user.orders.sum :total_price
  end

  def create
    @products = Product.load_product_by_id " ", session[:cart]
    order = current_user.orders.create total_price: session[:total_price],
      status: Settings.order.new
    @products.each do |product|
      order.order_details.create quantity: session[product.id],
        product_id: product.id
    end
    session[:cart] = nil
    session[:total_price] = nil
    flash[:success] = t :order_successfully
    redirect_to root_path
  end

  def show
    @order = Order.find_by id: params[:id]
    order_details = OrderDetail.select{|x| x.order_id == @order.id}
    @product_quantity = Array.new
    order_details.each do |order|
      product = Product.find_by id: order.product_id
      @product_quantity.append [product, order.quantity]
    end
  end

  private

  def check_current_user
    if !current_user.present? || current_user.admin?
      flash[:warning] = t :login_please_as_user
      redirect_to root_path
    end
  end
end
