class ChangeDefaultProduct < ActiveRecord::Migration[5.0]
  def change
    change_column_default :products, :price, 0
    change_column_default :products, :is_hot, false
    change_column_default :products, :rate_average, 0
    change_column_default :products, :in_stock, 0
    add_column :suggest_products, :name, :string
  end
end
