module BxBlockEmailNotifications
  class EmailNotificationSerializer
    include FastJsonapi::ObjectSerializer
    attributes *[
        :id,
        :notification,
        :created_at,
        :updated_at,
        :send_to_email,
        :sent_at
    ]
  end
end
