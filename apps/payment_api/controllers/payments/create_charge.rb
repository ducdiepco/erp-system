module PaymentApi::Controllers::Payments
  class CreateCharge
    include PaymentApi::Action
    include PaymentApi::MerchantAction

    params do
      required(:amount).filled
      required(:is_type).filled
      required(:customer_id).filled
      optional(:card_id).maybe(:str?)

      rule(card_id_presence: [:card_id, :is_type]) do |card_id, is_type|
        is_type.excluded_from?(%w(payline)).then(card_id.filled?)
      end
    end

    private

    def action
      'charge_customer_with_card_id'
    end
  end
end
