class PaymentApi::Merchants::CardEntity < Hanami::Entity
  attributes do
    attribute :card_id,       Types::Coercible::String
    attribute :customer_id,   Types::Coercible::String
    attribute :merchant,      Types::Coercible::String
    attribute :response_text, Types::Coercible::String
    attribute :created_at,    Types::DateTime.default { DateTime.now }
  end
end
