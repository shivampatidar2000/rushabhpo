module BxBlockPaymentAdmin
  class PaymentAdmin < BxBlockPaymentAdmin::ApplicationRecord
    self.table_name = :payment_admins
    belongs_to :current_user, class_name: 'AccountBlock::Account'
    belongs_to :account, class_name: 'AccountBlock::Account'
    enum payment_method: [:paypal, :apple_pay]
  end
end
