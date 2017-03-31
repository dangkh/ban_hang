class AddCodeToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :code, :string, default: nil
  end
end
