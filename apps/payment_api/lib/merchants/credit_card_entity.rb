class Merchants::CreditCardEntity < Hanami::Entity
  attributes do
    attribute :card_number,    Types::Coercible::String
    attribute :card_month,    Types::Coercible::String
    attribute :card_year,    Types::Coercible::String
    attribute :card_cvc, Types::Coercible::String
    attribute :first_name, Types::String
    attribute :last_name, Types::String
    attribute :address, Types::String
    attribute :city, Types::String
    attribute :state, Types::String
    attribute :zip, Types::String
    attribute :country, Types::String.default('US')
    attribute :email, CustomTypes::Email
  end

  def card_exp
    card_month + '/' + card_year
  end
end
