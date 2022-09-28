module BxBlockProductProperties
    class Color < BxBlockProductProperties::ApplicationRecord
      self.table_name = :colors
    #   accepts_nested_attributes_for :product_details, allow_destroy: true
    end
  end