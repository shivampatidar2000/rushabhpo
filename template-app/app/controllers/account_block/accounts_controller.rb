module AccountBlock
  class AccountsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :find_user, only:[:account_activation_email]
    before_action :validate_json_web_token, only: [:search, :show, :update, :destroy, :get_reset_password_token ]

    def create
       case params[:data][:type] #### rescue invalid API format
      when 'sms_account'
        validate_json_web_token

        unless valid_token?
          return render json: {errors: [
            {token: 'Invalid Token'},
          ]}, status: :bad_request
        end

        begin
          @sms_otp = SmsOtp.find(@token[:id])
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {phone: 'Confirmed Phone Number was not found'},
          ]}, status: :unprocessable_entity
        end

        params[:data][:attributes][:full_phone_number] =
          @sms_otp.full_phone_number
        @account = SmsAccount.new(jsonapi_deserialize(params))
        @account.activated = true
        if @account.save
          render json: SmsAccountSerializer.new(@account, meta: {
            token: encode(@account.id)
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      when 'email_account'
        account_params = jsonapi_deserialize(params)

        query_email = account_params['email'].downcase
        account = EmailAccount.where('LOWER(email) = ?', query_email).first

        validator = EmailValidation.new(account_params['email'])

        return render json: {errors: [
          {account: 'Email invalid'},
        ]}, status: :unprocessable_entity if account || !validator.valid?

        @account = EmailAccount.new(jsonapi_deserialize(params))
        @account.platform = request.headers['platform'].downcase if request.headers.include?('platform')

        if @account.save
          # EmailAccount.create_stripe_customers(@account)
          EmailValidationMailer
            .with(account: @account, host: request.base_url)
            .activation_email.deliver
          render json: EmailAccountSerializer.new(@account, meta: {
            token: encode(@account.id),
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      when 'social_account'
        @account = SocialAccount.new(jsonapi_deserialize(params))
        @account.password = @account.email
        if @account.save
          render json: SocialAccountSerializer.new(@account, meta: {
            token: encode(@account.id),
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      else
        render json: {errors: [
          {account: 'Invalid Account Type'},
        ]}, status: :unprocessable_entity
      end
    end


    def show
      @account = Account.find_by_id(params[:id])
      byebug
      if @account
        render json: AccountSerializer.new(@account).serializable_hash, status: :ok
        
      else
        render json: {errors: format_activerecord_errors(@account.errors)},
             status: :unprocessable_entity
      end    
    end

    def update
      @account = Account.find_by_id(@token.id)
      if @account.update(account_params)
        render json: AccountSerializer.new(@account).serializable_hash, status: :ok
       else
        render json: {errors: format_activerecord_errors(@account.errors)},
             status: :unprocessable_entity
      end
    end
 
    def get_reset_password_token
      @account = Account.find_by_id(@token.id)
      render json: {
        token: encode(@account.id),
        api_path: "/account_block/accounts/#{@account.id}"
      }
    end

    def destroy
      @account = Account.find_by_id(@token.id)
      if @account.destroy!
        render json: {account: "account has been deleted successfully"}, status: :ok
       else
        render json: {errors: format_activerecord_errors(@account.errors)},
             status: :unprocessable_entity
      end
    end
    def search
      @accounts = Account.where(activated: true)
                    .where('first_name ILIKE :search OR '\
                           'last_name ILIKE :search OR '\
                           'email ILIKE :search', search: "%#{search_params[:query]}%")
      if @accounts.present?
        render json: AccountSerializer.new(@accounts, meta: {message: 'List of users.'
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not found any user.'}]}, status: :ok
      end
    end

    private

    def encode(id)
      BuilderJsonWebToken.encode id
    end

    def search_params
      params.permit(:query)
    end

    def current_user
      @account = AccountBlock::Account.find_by(id: @token&.id)
      render json: {errors: [{token: I18n.t('invalid_token')},
        ]}, status: :unprocessable_entity and return unless @account.present?
    end

    def account_params
      params.require(:account).permit(:id, :first_name, :last_name, :email, :password, :password_confirmation)
    end
  end
end
