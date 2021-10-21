# This migration comes from bx_block_email_notifications (originally 20210305164333)
class CreateEmailNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :email_notifications do |t|
      t.references :notification, null: false, foreign_key: true
      t.string :send_to_email
      t.datetime :sent_at

      t.timestamps
    end
  end
end
