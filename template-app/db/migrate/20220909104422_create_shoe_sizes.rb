class CreateShoeSizes < ActiveRecord::Migration[6.0]
  def change
    create_table :shoe_sizes do |t|
      t.integer :shoe_size
      t.string :size_type
      t.string :size_gender_type

      t.timestamps
    end
  end
end
