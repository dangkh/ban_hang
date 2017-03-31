class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def check_product_quantity
    return quantity > product.in_stock ? true : false
  end

  def update_product_quantity
    product.update in_stock: product.in_stock - quantity
    product.update sold_quantity: product.sold_quantity + quantity
  end

  class << self
    def load_orders_by_month time
      OrderDetail.select{|order| order.created_at > time}.sort_by{|order| order.product_id}
    end
  end
end
