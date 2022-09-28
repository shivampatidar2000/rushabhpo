class AddColumnToProductDetails < ActiveRecord::Migration[6.0]
  def change
    add_column :products_details, :color_id, :bigint
    add_column :products_details, :arch_type_id, :bigint
    add_column :products_details, :shoe_size_id, :bigint
    add_column :products_details, :shoe_type_id, :bigint
    add_column :products_details, :template_length_id, :bigint
    add_column :products_details, :template_width_id, :bigint
  end
end
