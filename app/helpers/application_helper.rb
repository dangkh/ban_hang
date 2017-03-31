module ApplicationHelper
  def picture_for product, top = nil
    product.image? ? image_for_top(product.image, top) : image_for_top("missing.jpg", top)
  end

  def image_for_top picture, top
    top.nil? ? image_tag(picture, class: "image-product-side") :
      image_tag(picture, class: "image-product-detail")
  end

  def index_for counter, page, limit
    (page - 1) * limit + counter + 1
  end

  def sortable column
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to column, sort: column, direction: direction
  end

  def validate_product product_id
    @product.in_stock.present? && @product.in_stock > 0 &&
      session[@product.id].nil? ? true : false
  end

  def time_type time
    time.to_time.strftime Settings.activity_time_format
  end

  def check_role_current_user
    if current_user.nil? || current_user.admin?
      flash[:warning] = t :log_in_as_user
      redirect_to :back
    end
  end

  def get_product products, id
    products[id]
  end
end
