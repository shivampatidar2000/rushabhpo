module BxBlockPosts
  class PostsController < ApplicationController

    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token
    before_action :check_image_video_formate, only: [:create, :update]
    before_action :check_account_activated

    def index
      posts = BxBlockPosts::Post.all
      if posts.present?
        render json: PostSerializer.new(posts, params: {current_user: current_user}).serializable_hash
      else
        render json: {data: []},
            status: :ok
      end
    end

    def create
      service = BxBlockPosts::Create.new(current_user, post_params)
      new_post = service.execute
      if new_post.persisted?
        new_post.upload_post_images(params[:data][:attributes][:images]) if params[:data][:attributes][:images].present?

        render json: PostSerializer.new(new_post).serializable_hash,
               status: :ok
      else
        render json: ErrorSerializer.new(new_post).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def show
      post = BxBlockPosts::Post.find_by(id: params[:id])

      return render json: {errors: [
          {Post: 'Not found'},
        ]}, status: :not_found if post.blank?
      json_data = PostSerializer.new(post, params: {current_user: current_user}).serializable_hash
      render json: json_data
    end

    def update
      post = BxBlockPosts::Post.find_by(id: params[:id], account_id: current_user.id)

      return render json: {errors: [
          {Post: 'Not found'},
        ]}, status: :not_found if post.blank?

      post = BxBlockPosts::Update.new(post, post_params).execute

      if post.persisted?
        post.upload_post_images(params[:data][:attributes][:images]) if params[:data][:attributes][:images].present?
        render json: PostSerializer.new(post, params: {current_user: current_user}).serializable_hash
      else
        render json: {errors: format_activerecord_errors(post.errors)},
            status: :unprocessable_entity
      end
    end

    def search
      @posts = Post.where('description ILIKE :search', search: "%#{search_params[:query]}%")
      render json: PostSerializer.new(@posts, params: {current_user: current_user}).serializable_hash, status: :ok
    end

    def destroy
      post = BxBlockPosts::Post.find_by(id: params[:id], account_id: current_user.id)
      return if post.nil?
      if post.destroy
        render json: {}, status: :ok
      else
        render json: ErrorSerializer.new(post).serializable_hash,
               status: :unprocessable_entity
      end
    end

    private

    def post_params
      params.require(:data)[:attributes].permit(
        :name, :description, :body, :category_id, :location,
        tag_list: [],
        images: [],
        location_attributes: [:id, :address, :_destroy]
      )
    end

    def search_params
      params.permit(:query)
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end

    def check_image_video_formate
      return if params[:data][:attributes][:images].blank?
      image_formats = %w(image/jpeg image/jpg image/png)
      video_formats = %w(video/mp4 video/mov video/wmv video/flv video/avi video/mkv video/webm)
      params[:data][:attributes][:images].each do |image_data|
        content_type = image_data[:content_type].to_s.split('/').first
        if image_formats.exclude?(image_data[:content_type]) && content_type == 'image'
          render json: {errors: ["The image is unsupported type, supported formates are #{image_formats}"]},
            status: :unprocessable_entity
        elsif video_formats.exclude?(image_data[:content_type]) && content_type == 'video'
          render json: {errors: ["The video is unsupported type, supported formates are #{video_formats}"]},
            status: :unprocessable_entity
        end
      end
    end
  end
end
