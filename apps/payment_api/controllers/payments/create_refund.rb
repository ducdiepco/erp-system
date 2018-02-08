module PaymentApi::Controllers::Payments
  class CreateRefund
    include PaymentApi::Action
    include PaymentApi::MerchantAction

    params do
      required(:is_type).filled
      required(:amount).filled
      required(:transaction_id).filled
    end

    private

    def action
      'refund'
    end
  end
end
