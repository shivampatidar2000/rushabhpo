module AccountBlock
  class EmailAccount < Account
    include Wisper::Publisher
    validates :email, presence: true

    def self.create_stripe_customers(account)
      stripe_customer = Stripe::Customer.create({
        email:  account.email
      })
      account.stripe_id = stripe_customer.id
      account.save
    end
  end
end
