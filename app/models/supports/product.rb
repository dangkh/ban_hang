class Supports::Product
  attr_reader :product

  def initialize product, user
    @product = product
    @user = user
  end

  def relate
    @relate ||= Product.take_relate_product @product
  end

  def hot
    @hot = Product.take_hot_product @product
  end

  def randomizes
    @randomizes = Product.take_random_product
  end

  def rating
    @user.nil? ? nil : Rating.find_by(product_id: @product.id, user_id: @user.id)
  end
end
