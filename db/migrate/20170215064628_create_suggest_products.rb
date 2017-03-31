class CreateSuggestProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :suggest_products do |t|
      t.string :description
      t.integer :status
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
