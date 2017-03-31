class SendOrderMailer < ApplicationMailer

  def send_order user, order_object
    @user = user
    order_details = OrderDetail.select{|order_detail|
      order_detail.order_id == order_object.id}
    @product_quantity = Array.new
    order_details.each do |order|
      product = Product.find_by id: order.product_id
      @product_quantity.append [product, order.quantity]
    end
    mail to: @user.email, subject: "Order detail"
  end
end
