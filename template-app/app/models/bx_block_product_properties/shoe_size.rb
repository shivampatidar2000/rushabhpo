module BxBlockProductProperties
    class ShoeSize < BxBlockProductProperties::ApplicationRecord
      self.table_name = :shoe_sizes
    #   accepts_nested_attributes_for :product_details, allow_destroy: true
      # scope :uk, -> { where("size_type = ?", 'UK')}
      # scope :us, -> { where("size_type = ?", 'US')}
      # scope :international, -> { where("size_type = ?", 'EU')}
      # scope :eu, -> { where("size_type = ?", 'EU')}
    
      # def display_name
      #   "#{self.shoe_size}"
      # end
    end
  end