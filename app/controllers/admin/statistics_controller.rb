class Admin::StatisticsController < ApplicationController
  before_action :verify_admin, :authenticate_user!

  def index
    month_start = Time.new Time.now.year, Time.now.mon
    orders = OrderDetail.load_orders_by_month month_start
    @products = Product.load_product_by_order orders
    respond_to do |format|
      format.html
      format.xls
    end
    @data = Array.new
    tmp = Array.new
    @products.each do |product, quantity|
      @data.append [product.name, quantity]
      tmp.append [product.category_id, quantity]
    end
    tmp.sort!()
    data_tmp = Array.new
    tmp.each do |category_id, quantity|
      if data_tmp.present? && category_id == data_tmp.last.first.id
          data_tmp.last[1] += quantity
        else
          tmp_category = Category.find_by id: category_id
          data_tmp.append [tmp_category, quantity]
      end
    end
    data_tmp.sort{|a,b| b[1] <=> a[1]}.take(7)
    @data1 = Array.new
    data_tmp.each do |category, quantity|
      @data1.append [category.name, quantity]
    end
    StatisticsWorker.perform_at load_time
    @products = Kaminari.paginate_array(@products).page(params[:page])
      .per Settings.product.per_page
    @user1s = User.all.order(created_at: :desc).take(10)
    tmp = Order.group(:user_id).sum(:total_price).take(10)
    @user2s = Array.new
    tmp.each do |id, sum|
      user_tmp = User.find_by id: id
      @user2s.append [user_tmp, sum]
    end
  end

  private

  def load_time
    year = Time.now.year
    month = Time.now.mon
    day = Time.days_in_month month, year
    Time.new year, month, day
  end
end
