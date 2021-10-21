# == Schema Information
#
# Table name: order_statuses
#
#  id         :bigint           not null, primary key
#  name       :string
#  status     :string
#  active     :boolean          default(TRUE)
#  event_name :string
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockOrderManagement
  class OrderStatus < BxBlockOrderManagement::ApplicationRecord
    self.table_name = :order_statuses

    has_many :orders
    has_many :order_items

    validates_uniqueness_of :status

    before_save :add_status

    scope :new_statuses, ->{
      where.not(status: [
        :in_cart,
        :created,
        :placed,
        :confirmed,
        :in_transit,
        :delivered,
        :cancelled,
        :refunded,
        :payment_failed,
        :returned,
        :payment_pending]
      )
    }

    USER_STATUSES = %w[
    in_cart
      created
      placed
      payment_failed
      payment_pending
    ]

    CUSTOM_STATUSES = %w[
      in_cart
      created
      placed
      confirmed
      in_transit
      delivered
      cancelled
      refunded
      payment_failed
      returned
      payment_pending
    ]

    private

    def add_status
      unless self.status.present?
        self.status = self.name.to_s.downcase.parameterize.underscore
      end
      unless self.event_name.present?
        self.event_name = self.name.to_s.downcase.parameterize.underscore
      end
    end

  end
end
