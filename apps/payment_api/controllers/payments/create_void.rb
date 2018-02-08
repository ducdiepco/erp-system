module PaymentApi::Controllers::Payments
  class CreateVoid
    include PaymentApi::Action
    include PaymentApi::MerchantAction

    params do
      required(:is_type).filled
      required(:transaction_id).filled
    end

    private

    def action
      'void'
    end
  end
end
