module Merchants
  class Action
    def initialize(params, action, credential)
      @params = params
      @action = action
      @credential = credential
    end

    def self.send(params:, action:, credential:)
      new(params, action, credential).send(:call)
    end

    private

    def call
      merchant.send(action)
    end

    def merchant
      @merhant ||= MerchantType.for(credential, params)
    end

    attr_reader :params, :action, :credential
  end
end
