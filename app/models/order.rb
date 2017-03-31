class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  enum status: [:wait, :success, :delay]
  before_update :check_product_quantity_before_update
  ransacker :status, formatter: proc {|v| statuses[v]}

  class << self
    def load_info_to_chatwork order
      info = ""
      order.order_details.each do |order_detail|
        price = order_detail.product.price * order_detail.quantity
        info += "#{order_detail.product.name} #{order_detail.quantity} #{price}$\n"
      end
      info += "#{I18n.t(:total_price)} #{order.total_price}"
      return info
    end
  end

  private
  def check_product_quantity_before_update
    if status == Settings.success
      order_details.each do |order_detail|
        if order_detail.check_product_quantity
          throw :abort
        end
      end
      order_details.each do |order_detail|
        order_detail.update_product_quantity
      end
    end
  end
end
