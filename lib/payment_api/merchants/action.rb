module PaymentApi
  module Merchants
    class Action

      def execute(params:, action:, credential:)
        merchant(credential, params).send(action)
      end

      private

      def merchant(credential, params)
        MerchantType.for(credential, params)
      end

    end
  end
end
