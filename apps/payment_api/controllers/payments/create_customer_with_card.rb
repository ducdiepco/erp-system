module PaymentApi::Controllers::Payments
  class CreateCustomerWithCard
    include PaymentApi::Action
    include PaymentApi::MerchantAction

    params do
      required(:is_type).filled
      required(:card_number).filled
      required(:card_month).filled
      required(:card_year).filled
      required(:card_cvc).filled
      required(:first_name).filled
      required(:last_name).filled
      required(:email).filled
      optional(:address).maybe(:str?)
      optional(:city).maybe(:str?)
      optional(:state).maybe(:str?)
      optional(:zip).maybe(:str?)
      optional(:country).maybe(:str?)
    end

    private

    def action
      'create_customer_and_add_card'
    end

  end
end
