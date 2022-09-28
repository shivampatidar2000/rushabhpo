class CreateTemplateLengths < ActiveRecord::Migration[6.0]
  def change
    create_table :template_lengths do |t|
      t.string :template_length

      t.timestamps
    end
  end
end
