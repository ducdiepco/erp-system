module PaymentApi
  module Merchants
    class Payline < Merchants::Base
      def initialize(credential:, entity:, type_of_merchant:)
        raise ArgumentError.new('not Credit Card Entity') unless entity.instance_of? CreditCardEntity
        @credential  = ""
        @credential = @credential + "username=" + credential[:username] + "&"
        @credential += "password=" + credential[:password] + "&"
        @post_url = credential[:url]
        @entity = entity
        @merchant_name = type_of_merchant
      end

      def create_customer_and_add_card
        query = @credential
        query += set_card_info
        query += set_billing_info
        query += "customer_vault=add_customer"
        to_customer(doPost(query))
      end

      def charge_customer_with_card_id
        query = @credential
        query += "amount=" + entity.amount.to_s + "&"
        # cvv is optinal
        query += "cvv=" + entity.card_cvc + "&" if entity.card_cvc
        query += "customer_vault_id=" + entity.customer_id
        to_transaction(doPost(query))
      end

      def refund
        query = @credential
        query += "transactionid=#{entity.transaction_id}" + "&"
        query += "amount=#{entity.amount}" + "&"
        query += "type=refund"
        to_refund(doPost(query))
      end

      def add_card_to_existing_client
        query = @credential
        query += set_card_info
        query += set_billing_info
        query += "customer_vault_id=#{entity.customer_id}" + "&"
        query += "customer_vault=update_customer"
        to_card(doPost(query))
      end

      private

      def doPost(query)
        curlObj = Curl::Easy.new(post_url)
        curlObj.connect_timeout = 30
        curlObj.timeout = 30
        curlObj.header_in_body = false
        curlObj.ssl_verify_peer=false
        curlObj.post_body = query
        curlObj.perform()
        data = curlObj.body_str
        result = decode data
        raise PaymentApi::MerchantError, result["responsetext"] \
          unless ["100","200"].include? result["response_code"]
            result
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

        def decode(data)
          Hash[URI::decode_www_form(data)]
        end

        def to_customer(response)
          Merchants::CustomerEntity.new(
            customer_id:   response['customer_vault_id'],
            card_id:       response['billing_id'],
            merchant:      merchant_name,
            response_text: response['responsetext'],
          )
        end

        def to_transaction(response)
          Merchants::TransactionEntity.new(
            customer_id:    response['customer_vault_id'],
            transaction_id: response['transactionid'],
            amount:         response['amount_authorized'],
            response_text:  response['responsetext'],
            merchant:       merchant_name,
            status:         status(response['response_code'])
          )
        end

        def to_refund(response)
          Merchants::RefundEntity.new(
            transaction_id: response['transactionid'],
            merchant:       merchant_name,
            response_text:  response['responsetext'],
          )
        end

        def to_card(response)
          Merchants::CardEntity.new(
            card_id:       response['billing_id'],
            customer_id:   response['customer_vault_id'],
            merchant:      merchant_name,
            response_text: response['responsetext']
          )
        end

        def status(code)
          case code
          when '200'
            :declined
          when '100'
            :success
          end
        end

        attr_reader :credential, :entity, :post_url, :merchant_name
      end
    end
  end
