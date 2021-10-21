# This migration comes from bx_block_custom_ads (originally 20200913182238)
class Advertisement < ActiveRecord::Migration[6.0]
  def change
    create_table :advertisements do |t|
      t.string   :name
      t.text     :description
      t.integer  :plan_id
      t.string   :duration
      t.integer  :advertisement_for
      t.integer  :status
      t.integer  :seller_account_id
      t.datetime :start_at
      t.datetime :expire_at
    end
  end
end
