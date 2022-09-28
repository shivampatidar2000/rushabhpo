class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :state
      t.string :gender
      t.bigint :category_id
      t.string :unique_id
      t.string :description
      t.integer :price
      t.boolean :status

      t.timestamps
    end
  end
end
