class PaymentApi::Merchants::CustomerEntity < Hanami::Entity
  attributes do
    attribute :customer_id,   Types::Coercible::String
    attribute :card_id,       Types::Coercible::String
    attribute :merchant,      Types::Coercible::String
    attribute :created_at,    Types::DateTime.default { DateTime.now }
    attribute :response_text, Types::Coercible::String
  end
end
