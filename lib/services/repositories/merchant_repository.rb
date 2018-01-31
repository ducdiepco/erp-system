class MerchantRepository < Hanami::Repository
  def find_by_type(type)
    merchants.where(is_type: type).map_to(Merchant).one
  end
end
