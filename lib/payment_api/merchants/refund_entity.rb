class PaymentApi::Merchants::RefundEntity < Hanami::Entity
  attributes do
    attribute :transaction_id, Types::Coercible::String
    attribute :merchant,       Types::Coercible::String
    attribute :response_text,  Types::Coercible::String
    attribute :created_at,     Types::DateTime.default { DateTime.now }
    attribute :amount,         Types::Coercible::String
  end
end
