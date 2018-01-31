module PaymentApi::Controllers::Payments
  class Charge
    include PaymentApi::Action

    def call(params)
      self.body = 'OK'
    end
  end
end
