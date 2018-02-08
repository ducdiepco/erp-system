class PaymentApi::Merchants::TransactionEntity < Hanami::Entity
  attributes do
    attribute :transaction_id, Types::Coercible::String
    attribute :customer_id,    Types::Coercible::String
    attribute :merchant,       Types::Coercible::String
    attribute :amount,         Types::Coercible::String
    attribute :response_text,  Types::Coercible::String
    attribute :created_at,     Types::DateTime.default { DateTime.now }
    attribute :status,         Types::Coercible::String
  end
end
