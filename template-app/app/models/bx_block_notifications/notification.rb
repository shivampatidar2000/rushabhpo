module BxBlockNotifications
  class Notification < ApplicationRecord
    self.table_name = :notifications
    belongs_to :account , class_name: 'AccountBlock::Account'

    validates :headings, :contents, :account_id, presence: true, allow_blank: false
  end
end
