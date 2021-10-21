# This migration comes from bx_block_order_management (originally 20201013132532)
class AddColumnsToBxBlockOrderManagementOrder < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :account, index: true
    add_reference :orders, :coupon_code, index: true
    add_column :orders, :delivery_address_id, :bigint
    add_column :orders, :sub_total, :decimal, default: 0.0
    add_column :orders, :total, :decimal, default: 0.0
    add_column :orders, :status, :string
    add_column :orders, :applied_discount, :decimal, default: 0.0
    add_column :orders, :cancellation_reason, :text
    add_column :orders, :order_date, :datetime
    add_column :orders, :is_gift, :boolean, default: false
    add_column :orders, :placed_at, :datetime
    add_column :orders, :confirmed_at, :datetime
    add_column :orders, :in_transit_at, :datetime
    add_column :orders, :delivered_at, :datetime
    add_column :orders, :cancelled_at, :datetime
    add_column :orders, :refunded_at, :datetime
    add_column :orders, :source, :string
    add_column :orders, :shipment_id, :string
    add_column :orders, :delivery_charges, :string
    add_column :orders, :tracking_url, :string
    add_column :orders, :schedule_time, :datetime
    add_column :orders, :payment_failed_at, :datetime
    add_column :orders, :returned_at, :datetime
    add_column :orders, :tax_charges, :decimal, default: 0.0
    add_column :orders, :deliver_by, :integer
    add_column :orders, :tracking_number, :string
    add_column :orders, :is_error, :boolean, default: false
    add_column :orders, :delivery_error_message, :string
    add_column :orders, :payment_pending_at, :datetime
    add_column :orders, :order_status_id, :integer
  end
end
