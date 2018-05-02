require_relative "./base"

module PaymentApi
  module Merchants
    class Authorizenet < Merchants::Base
      include AuthorizeNet::API
      def initialize(credential:, entity:, type_of_merchant:)
        raise ArgumentError.new('not Credit Card Entity') unless entity.instance_of? CreditCardEntity
        @transaction = Transaction.new(
          credential[:login_id],
          credential[:key],
          gateway:    credential[:gateway],
          verify_ssl: credential[:verify_ssl]
        )
        @entity = entity
        @merchant_name = type_of_merchant
      end

      def create_customer_and_add_card
        request = CreateCustomerProfileRequest.new
        payment = PaymentType.new(CreditCardType.new(
          entity.card_number, entity.card_exp_year, entity.card_cvc
        ))
        profile = CustomerPaymentProfileType.new(nil,nil,payment,nil,nil)
        profile.billTo = CustomerAddressType.new
        profile.billTo.firstName = entity.first_name
        profile.billTo.lastName  = entity.last_name
        profile.billTo.zip       = entity.zip
        profile.billTo.address   = entity.address
        profile.billTo.city      = entity.city
        profile.billTo.state     = entity.state
        profile.billTo.state     = entity.state
        profile.billTo.country   = entity.country

        request.profile = CustomerProfileType.new(
          entity.merchant_customer_id,
          entity.full_name,
          entity.email,
          [profile],
          nil
        )
        response = handle_response(transaction.create_customer_profile(request))
        to_customer(response)
      end

      def charge_customer_with_card_id
        request = CreateTransactionRequest.new
        request.transactionRequest = TransactionRequestType.new()
        request.transactionRequest.amount = entity.amount
        request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
        request.transactionRequest.profile = CustomerProfilePaymentType.new
        request.transactionRequest.profile.customerProfileId = entity.customer_id
        request.transactionRequest.profile.paymentProfile = PaymentProfile.new(entity.card_id)
        request.transactionRequest.order = entity.order_id
        response = handle_response(transaction.create_transaction(request))
        to_transaction(response)
      end

      def refund
        request = CreateTransactionRequest.new
        request.transactionRequest = TransactionRequestType.new()
        request.transactionRequest.amount = entity.amount
        last_4 = get_trans_detail(entity.transaction_id).transaction.payment.creditCard.cardNumber[-4..-1]
        request.transactionRequest.payment = PaymentType.new
        request.transactionRequest.payment.creditCard = CreditCardType.new(last_4,'XXXX')
        request.transactionRequest.refTransId = entity.transaction_id
        request.transactionRequest.transactionType = TransactionTypeEnum::RefundTransaction
        response = handle_response(transaction.create_transaction(request))
        to_transaction(response)
      end

      def void
        request = CreateTransactionRequest.new
        request.transactionRequest = TransactionRequestType.new()
        request.transactionRequest.refTransId = entity.transaction_id
        request.transactionRequest.transactionType = TransactionTypeEnum::VoidTransaction
        response = handle_response(transaction.create_transaction(request))
        to_refund(response)
      end

      def add_card_to_existing_client
        request = CreateCustomerPaymentProfileRequest.new
        payment = PaymentType.new(CreditCardType.new(
          entity.card_number, entity.card_exp_year, entity.card_cvc
        ))
        profile = CustomerPaymentProfileType.new(nil,nil,payment,nil,nil)
        profile.billTo = CustomerAddressType.new
        profile.billTo.firstName = entity.first_name
        profile.billTo.lastName  = entity.last_name
        profile.billTo.zip       = entity.zip
        profile.billTo.address   = entity.address
        profile.billTo.city      = entity.city
        profile.billTo.state     = entity.state
        profile.billTo.state     = entity.state
        profile.billTo.country   = entity.country
        profile.defaultPaymentProfile = true;

        request.paymentProfile = profile
        request.customerProfileId = entity.customer_id
        response = handle_response(transaction.create_customer_payment_profile(request))
        to_card(response)
      end

      private

      def get_trans_detail(trans_id)
        request = GetTransactionDetailsRequest.new
        request.transId = trans_id
        handle_response(transaction.get_transaction_details(request))
      end

      def handle_response response
        raise PaymentApi::MerchantError, \
          response_text(response) \
          unless response.messages.resultCode == MessageTypeEnum::Ok
        response
      end

      def to_customer(response)
        Merchants::CustomerEntity.new(
          customer_id:   response.customerProfileId,
          card_id:       response.customerPaymentProfileIdList.numericString.first,
          merchant:      merchant_name,
          response_text: response.messages.messages[0].text,
        )
      end

      def to_transaction(response)
        Merchants::TransactionEntity.new(
          customer_id:    response.transactionResponse.profile.customerProfileId,
          transaction_id: response.transactionResponse.transId,
          amount:         entity.amount,
          response_text:  response_text(response),
          merchant:       merchant_name,
          status:         status(response.transactionResponse.responseCode)
        )
      end

      def to_card(response)
        Merchants::CardEntity.new(
          card_id:       response.customerPaymentProfileId,
          customer_id:   response.customerProfileId,
          merchant:      merchant_name,
          response_text: response_text(response),
        )
      end

      def to_refund(response)
        Merchants::RefundEntity.new(
          transaction_id: response.transactionResponse.transId,
          merchant:       merchant_name,
          response_text:  response_text(response),
        )
      end

      def response_text(response)
        if response.try(:transactionResponse).try(:errors) != nil
          response.transactionResponse.errors.errors[0].errorText
        else
          response.messages.messages[0].text
        end
      end

      def status(code)
        case code
        when AuthorizeNet::AIM::Response::ResponseCode::APPROVED
          :success
        when AuthorizeNet::AIM::Response::ResponseCode::DECLINED
          :declined
        when AuthorizeNet::AIM::Response::ResponseCode::ERROR
          :error
        when AuthorizeNet::AIM::Response::ResponseCode::HELD
          :held
        end
      end

      attr_reader :transaction, :entity, :merchant_name
      end
    end
  end
