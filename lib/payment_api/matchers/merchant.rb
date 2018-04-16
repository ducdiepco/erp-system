module PaymentApi
  module Matchers
    module Merchant

      SUCCESS_CASE = Dry::Matcher::Case.new(
        match:   -> value do
          value.success?
        end,
        resolve: -> value do
          value.value.to_hash
        end
      )

      FAILURE_CASE = Dry::Matcher::Case.new(
        match:   -> value do
          value.failure? && value.respond_to?(:messages)
        end,
        resolve: -> value do
          {message: value.messages}
        end
      )

      ERROR_CASE = Dry::Matcher::Case.new(
        match:   -> value do
          value.failure? && value.respond_to?(:value)
        end,
        resolve: -> value do
          result = value.value
          {message: result.to_s}
        end
      )

      Matcher = Dry::Matcher.new(
        success: SUCCESS_CASE,
        failure: FAILURE_CASE,
        error: ERROR_CASE,
      )
    end
  end
end
