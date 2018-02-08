module PaymentApi
  module Merchants
    class MerchantType
      extend Forwardable
      def initialize(credential, params)
        @credential = credential
        @params = params
      end

      def self.for(credential, params)
        new(credential, params).send(:for)
      end

      private

      def for
        case merchant
        when 'payline'
          Merchants::Payline.new(
            credential: token_access,
            entity: credit_card_entity,
            type_of_merchant: is_type,
          )
        when 'authorizenet'
          Merchants::Authorizenet.new(
            credential: token_access,
            entity: credit_card_entity,
            type_of_merchant: is_type,
          )
        else
          raise 'Unsupported type of merchant'
        end
      end

      def token_access
        Hanami::Utils::Hash.deep_symbolize(metadata)
      end

      def credit_card_entity
        Merchants::CreditCardEntity.new(params)
      end

      attr_reader :credential, :params
      def_delegators :credential, :is_type, :merchant, :metadata
    end
  end
end
