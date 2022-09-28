class SerializeHelper
    def self.pagination_dict(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      } if collection.present?
    end
  end