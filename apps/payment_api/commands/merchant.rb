module PaymentApi::Commands
  class Merchant
    include Dry::Monads::Try::Mixin
    include Import[
      merchant_repo:    'repositories.merchant',
      merchant_service: 'payment_api.services.merchant',
      events: 'events'
    ]

    alias m method

    def call params, action
      M.Right(params)
        .bind(m(:find_merchant))
        .bind(m(:execute), action)
        .fmap(m(:broad_cast_event), params, action)
    end

    private

    def find_merchant params
      merchant = merchant_repo.find_by_type(params[:is_type])
      if merchant
        M.Right(merchant: merchant, params: params)
      else
        M.Left('merchant not found')
      end
    end

    def execute input, action
      Try(PaymentApi::MerchantError) do
        merchant_service.execute(
          params:     input[:params],
          action:     action,
          credential: input[:merchant]
        )
      end.to_either
    end

    def broad_cast_event input, params, event
      events.broadcast(event, params: params, input: input.to_hash)
      input
    end

  end
end
