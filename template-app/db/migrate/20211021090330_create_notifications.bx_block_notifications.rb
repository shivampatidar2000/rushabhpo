# This migration comes from bx_block_notifications (originally 20201102074557)
class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :created_by
      t.string :headings
      t.string :contents
      t.string :app_url
      t.boolean :is_read, default: false
      t.datetime :read_at
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
