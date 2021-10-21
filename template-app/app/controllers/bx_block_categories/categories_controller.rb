module BxBlockCategories
  class CategoriesController < ApplicationController
    before_action :load_category, only: [:show, :update, :destroy]

    def create
      if params[:categories].blank? || params[:categories].size.zero?
        raise 'Wrong input data'
      end

      categories_to_create = params[:categories].map do |x|
        x.permit(:name).to_h
      end

      ActiveRecord::Base.transaction do
        @categories = Category.create!(categories_to_create)
      end

      render json: CategorySerializer.new(@categories, serialization_options)
                       .serializable_hash,
             status: :created
    end

    def show
      return if @category.nil?

      render json: CategorySerializer.new(@category, serialization_options)
                       .serializable_hash,
             status: :ok
    end

    def index
      serializer = if params[:sub_category_id].present?
                     categories = SubCategory.find(params[:sub_category_id])
                                      .categories
                     CategorySerializer.new(categories)
                   else
                     CategorySerializer.new(Category.all, serialization_options)
                   end

      render json: serializer, status: :ok
    end

    def destroy
      return if @category.nil?

      begin
        if @category.destroy
          remove_not_used_subcategories

          render json: { success: true }, status: :ok
        end
      rescue ActiveRecord::InvalidForeignKey
        message = "Record can't be deleted due to reference to a catalogue " \
                  "record"

        render json: {
          error: { message: message }
        }, status: :internal_server_error
      end
    end

    def update
      return if @category.nil?

      update_result = @category.update(name: params[:category_name])

      if update_result
        render json: CategorySerializer.new(@category).serializable_hash,
               status: :ok
      else
        render json: ErrorSerializer.new(@category).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def update_user_categories
      if current_user.update(category_ids: params[:categories_ids])
        serializer = CategorySerializer.new(current_user.categories)
        serialized = serializer.serializable_hash
        render json: serialized
      else
        render json: {errors: current_user.errors, status: :unprocessable_entity}
      end
    end

    private

    def load_category
      @category = Category.find_by(id: params[:id])

      if @category.nil?
        render json: {
            message: "Category with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def serialization_options
      options = {}
      options[:params] = { sub_categories: true }
      options
    end

    def remove_not_used_subcategories
      sql = "delete from sub_categories sc where sc.id in (
               select sc.id from sub_categories sc
               left join categories_sub_categories csc on
                 sc.id = csc.sub_category_id
               where csc.sub_category_id is null
             )"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end

