module PaymentApi
  module MerchantAction
    def self.included(action)
      action.class_eval do
        include Hanami::Serializer::Action
        include Import[
          'command': 'payment_api.commands.merchant',
          'matcher': 'payment_api.matchers.merchant'
        ]

        def call(params)
          if params.valid?
            result = command.call(params, action)
          else
            result = params.validate
          end
          matcher.(result) do |m|
            m.success { |value|  send_json(value, status: 201)  }
            m.error   { |value|  send_json(value, status: 200)}
            m.failure { |value| send_json(value, status: 200)}
          end
        end

      end
    end
  end
end
