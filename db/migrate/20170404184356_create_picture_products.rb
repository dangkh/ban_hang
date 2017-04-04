class CreatePictureProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :picture_products do |t|
      t.string :product_id
      t.string :integer

      t.timestamps
    end
  end
end
