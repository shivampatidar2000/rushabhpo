module BxBlockEmailNotifications
  class EmailNotification < ApplicationRecord
    self.table_name = :email_notifications
    belongs_to :notification , class_name: 'BxBlockNotifications::Notification'
  end
end
