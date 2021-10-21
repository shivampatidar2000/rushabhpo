module BxBlockEmailNotifications
  class EmailNotificationMailer < ApplicationMailer
    def notification_email
      @email_notification = params[:email_notification]
      notification = @email_notification.notification

      mail(to: @email_notification.send_to_email,
           body: notification.contents,
           subject: notification.headings)

      @email_notification.touch(:sent_at)
    end
  end
end
