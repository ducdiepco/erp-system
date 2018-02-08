module PaymentApi
  module Merchants
    class Base
      def create_customer_and_add_card
        raise_error __method__
      end

      def charge_customer_with_card_id
        raise_error __method__
      end

      def refund
        raise_error __method__
      end

      def void
        raise_error __method__
      end

      def add_card_to_existing_client
        raise_error __method__
      end

      def test
        raise_error __method__
      end

      private

      def raise_error(current_method)
        raise 'no ' + current_method.to_s + ' method on ' + current_class
      end

      def current_class
        self.class.name
      end
    end
  end
end
