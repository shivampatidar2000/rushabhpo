module BxBlockEmailNotifications
  class SendEmailNotificationService
    def initialize(notification)
      @notification = notification
    end

    def call
      email_notification = EmailNotification.create!(
        notification: @notification,
        send_to_email: @notification.account.email
      )
      EmailNotificationMailer.with(email_notification: email_notification)
        .notification_email.deliver_later

      email_notification
    end
  end
end
