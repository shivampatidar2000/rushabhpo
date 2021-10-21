# This migration comes from bx_block_upload_media (originally 20201013033450)
class CreateMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :media do |t|
      t.string :imageable_type
      t.string :imageable_id
      t.string :file_name
      t.string :file_size
      t.string :presigned_url
      t.integer :status
      t.string :category
    end
  end
end
