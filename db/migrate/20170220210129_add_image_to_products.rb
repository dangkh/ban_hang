class AddImageToProducts < ActiveRecord::Migration[5.0]

  class << self
    def up
      add_attachment :products, :image
    end

    def down
      remove_attachment :products, :image
    end
  end
end
