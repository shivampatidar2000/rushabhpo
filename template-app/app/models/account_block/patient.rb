module AccountBlock
    class  Patient < ApplicationRecord
        self.table_name = :patients
    #   include Wisper::Publisher
  
    #   validates :email, uniqueness: true, presence: true
    #   validates :unique_auth_id, presence: true
    has_many_attached :images
    belongs_to :account, class_name: 'AccountBlock::Account'
  

    end
  end
  