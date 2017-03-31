class Category < ApplicationRecord
  has_many :suggest_products, dependent: :destroy
  has_many :products, dependent: :destroy
  validates :name, presence: true, uniqueness: true, allow_blank: false

  class << self
    def get_cate_child parent_code
      result = Category.where(
        "code LIKE '%#{parent_code}%'").includes(:products)
      result = result.reject{|category| category.code == parent_code}
    end

    def get_child parent_id
      where parent_id: parent_id
    end

    def load_category_id id_array
      where id: id_array
    end
  end
end
