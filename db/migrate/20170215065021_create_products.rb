class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.integer :in_stock
      t.string :description
      t.integer :sold_quantity
      t.boolean :is_hot
      t.float :rate_average
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
