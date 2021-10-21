# == Schema Information
#
# Table name: order_transactions
#
#  id            :bigint           not null, primary key
#  account_id    :bigint           not null
#  order_id      :bigint           not null
#  charge_id     :string
#  amount        :integer
#  currency      :string
#  charge_status :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
module BxBlockOrderManagement
  class OrderTransaction < BxBlockOrderManagement::ApplicationRecord
    self.table_name = :order_transactions

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :order

  end
end
