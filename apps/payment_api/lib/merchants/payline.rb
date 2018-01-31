module Merchants
  class Payline
    def initialize(username:, password:, entity:)
      raise ArgumentError.new('not Credit Card Entity') unless entity.instance_of? CreditCardEntity
      @credential  = ""
      @credential = @credential + "username=" + username + "&"
      @credential += "password=" + password + "&"
      @entity = entity
    end

    def create_customer
      query = @credential
      query += set_card_info
      query += set_billing_info
      query += "customer_vault=add_customer"
      doPost(query)
      # CustomerObject.new(doPost(query))
    end

    private

    def doPost(query)
      curlObj = Curl::Easy.new(POST_URL)
      curlObj.connect_timeout = 30
      curlObj.timeout = 30
      curlObj.header_in_body = false
      curlObj.ssl_verify_peer=false
      curlObj.post_body = query
      curlObj.perform()
      data = curlObj.body_str
      result = decode data
      raise PaylineError, result["responsetext"] \
        unless result["response_code"] == "100"
          return result
      end

    def set_card_info
      card_info = ''
      card_info += "ccnumber=" + entity.card_number + "&"
      card_info += "ccexp=" + entity.card_exp + "&"
      card_info += "cvv=" + entity.card_cvc + "&"
      card_info
    end

    def set_billing_info
      query = ''
      billing_info.each do | key,value|
        if value
          query += key + "=" + value + "&"
        end
      end
      query
    end

    def billing_info
      billing = {}
      billing['firstname'] = entity.first_name
      billing['lastname']  = entity.last_name
      billing['address1']  = entity.address
      billing['city']      = entity.city
      billing['state']     = entity.state
      billing['zip']       = entity.zip
      billing['country']   = entity.country
      billing['email']     = entity.email
      billing
    end

    attr_reader :credential, :entity
    class PaylineError < StandardError; end
    POST_URL = 'https://secure.paylinedatagateway.com/api/transact.php'
  end
end
