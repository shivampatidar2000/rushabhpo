class ProductDetail < ActiveRecord::Migration[6.0]
  def change
    create_table :products_details do |t|
      t.string :name
      t.bigint :product_id
      t.string :description
      t.integer :price
      t.string :color
      t.integer :size

      t.timestamps
    end
  end
end
