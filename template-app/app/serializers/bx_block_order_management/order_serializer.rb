# == Schema Information
#
# Table name: orders
#
#  id                      :bigint           not null, primary key
#  order_number            :string
#  amount                  :float
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  account_id              :bigint
#  coupon_code_id          :bigint
#  delivery_address_id     :bigint
#  sub_total               :decimal(, )      default(0.0)
#  total                   :decimal(, )      default(0.0)
#  status                  :string
#  applied_discount        :decimal(, )      default(0.0)
#  cancellation_reason     :text
#  order_date              :datetime
#  is_gift                 :boolean          default(FALSE)
#  placed_at               :datetime
#  confirmed_at            :datetime
#  in_transit_at           :datetime
#  delivered_at            :datetime
#  cancelled_at            :datetime
#  refunded_at             :datetime
#  source                  :string
#  shipment_id             :string
#  delivery_charges        :string
#  tracking_url            :string
#  schedule_time           :datetime
#  payment_failed_at       :datetime
#  returned_at             :datetime
#  tax_charges             :decimal(, )      default(0.0)
#  deliver_by              :integer
#  tracking_number         :string
#  is_error                :boolean          default(FALSE)
#  delivery_error_message  :string
#  payment_pending_at      :datetime
#  order_status_id         :integer
#  is_group                :boolean          default(TRUE)
#  is_availability_checked :boolean          default(FALSE)
#  shipping_charge         :decimal(, )
#  shipping_discount       :decimal(, )
#  shipping_net_amt        :decimal(, )
#  shipping_total          :decimal(, )
#  total_tax               :float
#
module BxBlockOrderManagement
  class OrderSerializer < BuilderBase::BaseSerializer

    attributes *[
        :id,
        :order_number,
        :amount,
        :account_id,
        :coupon_code_id,
        :delivery_address_id,
        :sub_total,
        :total,
        :status,
        :applied_discount,
        :cancellation_reason,
        :order_date,
        :is_gift,
        :placed_at,
        :confirmed_at,
        :in_transit_at,
        :delivered_at,
        :cancelled_at,
        :refunded_at,
        :source,
        :shipment_id,
        :delivery_charges,
        :tracking_url,
        :schedule_time,
        :payment_failed_at,
        :payment_pending_at,
        :returned_at,
        :tax_charges,
        :deliver_by,
        :tracking_number,
        :is_error,
        :delivery_error_message,
        :order_status_id,
        :is_group,
        :is_availability_checked,
        :shipping_charge,
        :shipping_discount,
        :shipping_net_amt,
        :shipping_total,
        :total_tax,
        :created_at,
        :updated_at,
        :delivery_addresses,
        :razorpay_order_id
    ]

    attribute :order_items do |object, params|
      if object.present?
        OrderItemSerializer.new(
          object.order_items, { params: params }
        ).serializable_hash[:data]
      end
    end

    attribute :account do |object|
      if object.present?
        AccountBlock::AccountSerializer.new(object.account).serializable_hash[:data]
      end
    end

    attribute :order_transaction do |object|
      if object.present?
        object.order_transaction
      end
    end

  end
end
