class MerchantType
  def initialize(credential, params)
    @credential = credential
    @params = params
  end

  def self.for(credential, params)
    new(credential, params).send(:for)
  end

  private

  def for
    case type
    when 'payline'
      Merchants::Payline.new(
        username: metadata[:username],
        password: metadata[:password],
        entity: credit_card_entity
      )
    when 'authnet'
      Merchants::Authnet.new(credential)
    else
      raise 'Unsupported type of merchant'
    end
  end

  def metadata
    credential.metadata
  end

  def type
    credential.is_type
  end

  def credit_card_entity
    @credit_card_entity ||= Merchants::CreditCardEntity.new(params)
  end

  attr_reader :credential, :params
end
