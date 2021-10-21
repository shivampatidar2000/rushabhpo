# This migration comes from bx_block_order_management (originally 20201109090242)
class AddRazorpayOrderIdToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :razorpay_order_id, :string
  end
end
