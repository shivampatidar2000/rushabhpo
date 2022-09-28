class CreateArchTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :arch_types do |t|
      t.string :arch_type

      t.timestamps
    end
  end
end
