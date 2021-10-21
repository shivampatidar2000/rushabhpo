# This migration comes from bx_block_custom_form (originally 20200924171806)
class CreateSellerAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :seller_accounts do |t|
      t.string :firm_name
      t.string :full_phone_number
      t.text :location
      t.integer :country_code
      t.bigint :phone_number
      t.string :gstin_number
      t.boolean :wholesaler
      t.boolean :retailer
      t.boolean :manufacturer
      t.boolean :hallmarking_center
      t.float :buy_gold
      t.float :buy_silver
      t.float :sell_gold
      t.float :sell_silver
      t.string :deal_in, array: true, default: []
      t.text :about_us
      t.boolean :activated, :null => false, :default => false
      t.references :account, foreign_key: true, null: false
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :long, precision: 10, scale: 6

      t.timestamps
    end
  end
end
