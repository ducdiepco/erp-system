RSpec.describe PaymentApi::Merchants::Action, type: :lib do
  describe 'Authorizenet merchant' do
    let(:merchant) { described_class.new }
    before do
      @credential = double(
        'credential',
        is_type: 'authorizenet',
        merchant: 'authorizenet',
        metadata: {
          'login_id': '8caVU68X',
          'key': '2Qan5nQ2r994Kg59',
          'gateway': 'sandbox',
          'verify_ssl': 'false'
        },
      )
    end

    context 'create_customer_and_add_card' do
      let(:params) do
        {
          card_number: 4111111111111111,
          card_month:  10,
          card_year:   2020,
          card_cvc:    122,
          first_name:  'test_first_name2',
          last_name:   'test_last_name2',
          address:     '267 State Dr',
          zip:         '80246',
          city:        'Denver',
          state:       'CO',
          email:       'email@email2.com',
        }
      end

      it 'create customer and add card to authorizenet then return customer entity' do
        VCR.use_cassette "authorizenet create customer" do
          result = merchant.execute(
            params:     params,
            action:     'create_customer_and_add_card',
            credential: @credential
          )
          expect(result.customer_id).to eq('1503317269')
          expect(result.card_id).to eq('1502672408')
          expect(result.merchant).to eq('authorizenet')
          expect(result.created_at).not_to eq nil
        end
      end

      it 'return error' do
        VCR.use_cassette "authorizenet return error when create customer" do
          expect{merchant.execute(
            params:     params,
            action:     'create_customer_and_add_card',
            credential: @credential
          )}.to raise_error(PaymentApi::MerchantError, 'A duplicate record with ID 1503317269 already exists.')
        end
      end
    end

    context 'charge_customer_with_card_id' do
      let(:params) do
        {
          amount:      10,
          customer_id: 1503317269,
          card_id:     1502672408,
        }
      end

      it 'create customer and add card to authorizenet then return customer entity' do
        VCR.use_cassette "authorizenet create a charge from customer profile" do
          result = merchant.execute(
            params:     params,
            action:     'charge_customer_with_card_id',
            credential: @credential
          )
          expect(result.transaction_id).to eq('40009997464')
          expect(result.customer_id).to eq('1503317269')
          expect(result.amount).to eq('10.0')
          expect(result.merchant).to eq('authorizenet')
          expect(result.created_at).not_to eq nil
          expect(result.status).to eq 'success'
        end
      end

      it 'return declined transaction' do
        params[:amount] = 70.02
        VCR.use_cassette "authorizenet create a failed charge from customer profile" do
          result = merchant.execute(
            params:     params,
            action:     'charge_customer_with_card_id',
            credential: @credential
          )
          expect(result.transaction_id).to eq('60040038867')
          expect(result.customer_id).to eq('1503317269')
          expect(result.amount).to eq('70.02')
          expect(result.merchant).to eq('authorizenet')
          expect(result.created_at).not_to eq nil
          expect(result.status).to eq 'declined'
          expect(result.response_text).to eq 'This transaction has been declined.'
        end
      end

      it 'return unkown error' do
        params[:amount] = 70.05
        VCR.use_cassette "authorizenet create a unkown error on charge from customer profile" do
          result = merchant.execute(
            params:     params,
            action:     'charge_customer_with_card_id',
            credential: @credential
          )
          expect(result.transaction_id).to eq('60040039271')
          expect(result.customer_id).to eq('1503317269')
          expect(result.merchant).to eq('authorizenet')
          expect(result.created_at).not_to eq nil
          expect(result.status).to eq 'declined'
          expect(result.response_text).to eq 'An error occurred during processing. Call Merchant Service Provider.'
        end
      end
    end

    # context 'refund' do
    #   let(:params) do
    #     {
    #       amount:         39,
    #       transaction_id: 60026984524,
    #     }
    #   end
    #
    #   it 'refund successful' do
    #     VCR.use_cassette "authorizenet refund success" do
    #       result = merchant.execute(
    #         params:     params,
    #         action:     'refund',
    #         credential: @credential
    #       )
    #       require 'pry'; binding.pry
    #       expect(result.transaction_id).to eq('60026984631')
    #       expect(result.customer_id).to eq('1503317269')
    #       expect(result.amount).to eq('10.0')
    #       expect(result.merchant).to eq('authorizenet')
    #       expect(result.created_at).not_to eq nil
    #       expect(result.status).to eq 'success'
    #     end
    #   end
    #
    #   it 'return declined transaction' do
    #     params[:amount] = 70.02
    #     VCR.use_cassette "authorizenet create a failed charge from customer profile" do
    #       result = merchant.execute(
    #         params:     params,
    #         action:     'charge_customer_with_card_id',
    #         credential: @credential
    #       )
    #       expect(result.transaction_id).to eq('60040038867')
    #       expect(result.customer_id).to eq('1503317269')
    #       expect(result.amount).to eq('70.02')
    #       expect(result.merchant).to eq('authorizenet')
    #       expect(result.created_at).not_to eq nil
    #       expect(result.status).to eq 'declined'
    #       expect(result.response_text).to eq 'This transaction has been declined.'
    #     end
    #   end
    # end

    context 'void' do
      let(:params) do
        {
          amount:         10,
          transaction_id: 40009997464,
        }
      end

      it 'void successful' do
        VCR.use_cassette "authorizenet void success" do
          result = merchant.execute(
            params:     params,
            action:     'void',
            credential: @credential
          )
          expect(result.transaction_id).to eq('40009997464')
          expect(result.merchant).to eq('authorizenet')
          expect(result.created_at).not_to eq nil
        end
      end

      it 'return error' do
        params[:transaction_id] = 100000
        VCR.use_cassette "authorizenet void wrong transaction id" do
          expect{merchant.execute(
            params:     params,
            action:     'void',
            credential: @credential
          )}.to raise_error(PaymentApi::MerchantError, 'The transaction cannot be found.')
        end
      end
    end

    context 'add_card_to_existing_client' do
      let(:params) do
        {
          card_number: 4111111111111111,
          card_month:  10,
          card_year:   2020,
          card_cvc:    122,
          first_name:  'test_first_name2',
          last_name:   'test_last_name2',
          address:     '267 State Dr',
          zip:         '80246',
          city:        'Denver',
          state:       'CO',
          email:       'email@email2.com',
          customer_id: 1814508654,
        }
      end

      it 'add card successful' do
        VCR.use_cassette "authorizenet add card success" do
          result = merchant.execute(
            params:     params,
            action:     'add_card_to_existing_client',
            credential: @credential
          )
          expect(result.card_id).to eq('1809104497')
          expect(result.customer_id).to eq('1814508654')
          expect(result.merchant).to eq('authorizenet')
          expect(result.created_at).not_to eq nil
        end
      end

      it 'return error' do
        params[:card_number] = '44000000000'
        VCR.use_cassette "authorizenet add card by using wrong card number" do
          expect{merchant.execute(
            params:     params,
            action:     'add_card_to_existing_client',
            credential: @credential
          )}.to raise_error(PaymentApi::MerchantError, 'The field length is invalid for Card Number.')
        end
      end
    end

  end # end authorizenet
end
