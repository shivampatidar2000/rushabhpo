class CreateTemplateWidths < ActiveRecord::Migration[6.0]
  def change
    create_table :template_widths do |t|
      t.decimal :template_width

      t.timestamps
    end
  end
end
