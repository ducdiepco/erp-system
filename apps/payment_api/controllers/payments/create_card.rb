module PaymentApi::Controllers::Payments
  class CreateCard
    include PaymentApi::Action
    include PaymentApi::MerchantAction

    params do
      required(:is_type).filled
      required(:customer_id).filled
      required(:card_number).filled
      required(:card_month).filled
      required(:card_year).filled
      required(:card_cvc).filled
      required(:first_name).filled
      required(:last_name).filled
      optional(:email).maybe(:str?)
      required(:address).filled
      required(:city).filled
      required(:state).filled
      required(:zip).filled
      optional(:country).maybe(:str?)
    end

    private

    def action
      'add_card_to_existing_client'
    end
  end
end
