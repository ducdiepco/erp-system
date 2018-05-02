class PaymentApi::Merchants::CreditCardEntity < Hanami::Entity
  attributes do
    attribute :card_number,    Types::Coercible::String
    attribute :card_month,     Types::Coercible::String
    attribute :card_year,      Types::Coercible::String
    attribute :card_cvc,       Types::Coercible::String
    attribute :first_name,     Types::String
    attribute :last_name,      Types::String
    attribute :address,        Types::String
    attribute :city,           Types::String
    attribute :state,          Types::String
    attribute :zip,            Types::String
    attribute :country,        Types::String.default('US')
    attribute :email,          CustomTypes::Email
    attribute :amount,         Types::Coercible::Float
    attribute :card_id,        Types::Coercible::String
    attribute :customer_id,    Types::Coercible::String
    attribute :transaction_id, Types::Coercible::String
    attribute :order_id,       Types::Coercible::String
  end

  def full_name
    first_name + ' ' + last_name
  end

  def card_exp(separator = '/')
    card_month + separator + card_year
  end

  def card_exp_year(separator = '-')
    card_year + separator + card_month
  end

  # for authorizenet
  def merchant_customer_id
    nil
  end
end
