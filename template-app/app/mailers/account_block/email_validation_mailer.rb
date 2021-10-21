module AccountBlock
  class EmailValidationMailer < ApplicationMailer
    def activation_email
      @account = params[:account]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]

      token = encoded_token

      @url = "#{@host}/account/accounts/email_confirmation?token=#{token}"

      mail(
          to: @account.email,
          from: 'builder.bx_dev@engineer.ai',
          subject: 'Account activation') do |format|
        format.html { render 'activation_email' }
      end
    end

    private

    def encoded_token
      BuilderJsonWebToken.encode @account.id, 10.minutes.from_now
    end
  end
end
