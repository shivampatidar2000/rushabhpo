module BxBlockCategories
  class Category < BxBlockCategories::ApplicationRecord
    self.table_name = :categories

    mount_uploader :light_icon, ImageUploader
    mount_uploader :light_icon_active, ImageUploader
    mount_uploader :light_icon_inactive, ImageUploader
    mount_uploader :dark_icon, ImageUploader
    mount_uploader :dark_icon_active, ImageUploader
    mount_uploader :dark_icon_inactive, ImageUploader

    has_and_belongs_to_many :sub_categories,
                            join_table: :categories_sub_categories, dependent: :destroy

    has_many :contents, class_name: "BxBlockContentmanagement::Content", dependent: :destroy
    has_many :ctas, class_name: "BxBlockCategories::Cta", dependent: :nullify

    has_many :user_categories, class_name: "BxBlockCategories::UserCategory",
             join_table: "user_categoeries", dependent: :destroy
    has_many :accounts, class_name: "AccountBlock::Account", through: :user_categories,
             join_table: "user_categoeries"

    validates :name, uniqueness: true, presence: true
    validates_uniqueness_of :identifier, allow_blank: true

    enum identifier: ["k12", "higher_education", "govt_job", "competitive_exams", "upskilling"]
  end
end
