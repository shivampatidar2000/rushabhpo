module BxBlockNotifications
  class NotificationCreator
    attr_accessor :created_by,
                  :headings,
                  :contents,
                  :app_url,
                  :account_id
    def initialize(created_by, headings, contents, app_url, account_id)
      @created_by = created_by
      @headings = headings
      @contents = contents
      @app_url = app_url
      @account_id = account_id
    end

    def call
      @notification = BxBlockNotifications::Notification.create(
          created_by: created_by,
          headings: headings,
          contents: contents,
          app_url: app_url,
          account_id: account_id
      )
    end
  end
end
