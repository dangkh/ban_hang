class Product < ApplicationRecord
  belongs_to :category
  has_many :ratings, dependent: :destroy
  has_many :comments
  has_many :order_details, dependent: :destroy
  has_attached_file :image, styles: {small: Settings.small,
    medium: Settings.medium, large: Settings.large}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  class << self
    def take_hot_product item
      @result = Product.select{|product|
        product.is_hot && product.category_id == item.category_id}.shuffle.first
    end

    def take_relate_product item
      @result = Product.select{|product| product.category_id == item.category_id}
        .shuffle.take Settings.product.take_rand
    end

    def take_random_product
      @result = Product.order("RANDOM()").take Settings.product.take_rand
    end

    def take_new_product
      @result = Product.order(created_at: :desc).take(10).shuffle.take(5)
    end

    def get_product_by_category id, category
      @result = category.products.find_by id: id
    end

    def take_home_product
      @result = Product.select{|product|
      product.is_hot}.shuffle.take Settings.product.take_home
    end

    def search search, category_id
      search ? where("name LIKE '%#{search}%' AND category_id = #{category_id}") :
        where("category_id = #{category_id}")
    end

    def search_home search
      search ? where("name LIKE '%#{search}%'") : all
    end

    def load_product_by_id search, array
      @name_search = search.present? ? search : ""
      Product.where(id: array)
        .select{|product| product.name.include? @name_search}
    end

    def take_distinct_category
      Product.select(:category_id).distinct
    end

    def import file
      spreadsheet = open_spreadsheet file
      header = spreadsheet.row 1
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        product = find_by_id(row["id"]) || new
        product.attributes = row.to_hash
        product.save!
      end
    end

    def accessible_attributes
      ["name", "category_id", "in_stock", "price", "description", "sold_quantity"]
    end

    def open_spreadsheet file
      case File.extname file.original_filename
      when ".csv" then Roo::CSV.new file.path
      when ".xlsx" then Roo::Excelx.new file.path
      else raise "#{file.original_filename}"
      end
    end

    def load_product_statitic
      Product.where("sold_quantity > 0").includes :category
    end

    def to_csv options = {}
      CSV.generate(options) do |csv|
        csv << column_names
        all.each do |product|
          csv << product.attributes.values_at(*column_names)
        end
      end
    end

    def load_product_by_order orders
      products = Array.new
      orders.each do |order_detail|
        if products.present? && order_detail.product_id == products.last.first.id
          products.last[1] += order_detail.quantity
        else
          products.append [order_detail.product, order_detail.quantity]
        end
      end
      return products
    end
  end
end
