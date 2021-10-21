# This migration comes from bx_block_payment_admin (originally 20210416101829)
class CreatePaymentAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_admins do |t|
      t.string :transaction_id
      t.references :account, null: false, foreign_key: true
      t.references :current_user, references: :accounts, foreign_key: { to_table: :accounts}
      t.string :payment_status
      t.integer :payment_method
      t.decimal :user_amount, precision: 10, scale: 2
      t.decimal :post_creator_amount, precision: 10, scale: 2
      t.decimal :third_party_amount, precision: 10, scale: 2
      t.decimal :admin_amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
