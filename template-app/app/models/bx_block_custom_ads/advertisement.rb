module BxBlockCustomAds
  class Advertisement < ApplicationRecord

    self.table_name = :advertisements
    belongs_to :seller_account, class_name: "BxBlockCustomForm::SellerAccount"

    enum status: ["pending", "approved", "rejected"]
    enum advertisement_for: [:seller, :user]

    has_one_attached :banner

    before_create :add_status

    after_create :notify_admin

    def add_status
      self.status = 0
    end

    def notify_admin
      # AdvertisementMailer.notify_admin(advertisement:self).deliver
    end
  end
end
