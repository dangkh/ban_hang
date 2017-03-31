class SuggestProduct < ApplicationRecord
  belongs_to :user
  belongs_to :category
  enum status: [:wait, :accept, :cancel]

  def add_product_from_suggest
    Product.create name: name, description: description,
      category_id: category_id
  end
end
