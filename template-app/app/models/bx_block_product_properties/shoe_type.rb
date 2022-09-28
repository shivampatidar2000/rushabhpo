module BxBlockProductProperties
    class ShoeType < BxBlockProductProperties::ApplicationRecord
      self.table_name = :shoe_types
    #   accepts_nested_attributes_for :product_details, allow_destroy: true
    end
  end