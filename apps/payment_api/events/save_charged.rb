module PaymentApi::Events
  class SaveCharged
    include Hanami::Events::Mixin

    subscribe_to Container[:events], 'charge_customer_with_card_id'

    def call(payload)
      # WIP
      MerchantRepository.new.create(title: 'authorizenet', is_type: 'authorizenet-test', merchant: 'authorizenet', metadata: {'login_id': '8caVU68X', 'key': '2Qan5nQ2r994Kg59', 'gateway': 'sandbox', 'verify_ssl': 'false'})
    end
  end
end
