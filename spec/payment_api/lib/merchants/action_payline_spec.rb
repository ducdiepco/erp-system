RSpec.describe PaymentApi::Merchants::Action, type: :lib do
  describe 'payline merchant' do
    let(:merchant) { described_class.new }
    before do
      @credential = double(
        'credential',
        is_type: 'payline',
        merchant: 'payline',
        metadata: {
          'username': 'Isweep631',
          'password': '4aCtPCLoYhbBFVVEymLuXcKq',
          'url':      'https://secure.paylinedatagateway.com/api/transact.php'
        },
      )
    end

    context 'create_customer_and_add_card' do
      it 'create customer and add card to payline then return customer entity' do
        VCR.use_cassette "payline create customer" do
          params = {
            card_number: 4111111111111111,
            card_month:  10,
            card_year:   2020,
            card_cvc:    123,
            first_name:  'test_first_name',
            last_name:   'test_last_name',
            email:       'email@email.com',
          }
          result = merchant.execute(
            params:     params,
            action:     'create_customer_and_add_card',
            credential: @credential
          )
          expect(result.customer_id).to eq('1781524122')
          expect(result.card_id).to eq('1048710362')
          expect(result.merchant).to eq('payline')
          expect(result.created_at).not_to eq nil
        end
      end
    end

    context 'charge_customer_with_card_id' do
      it 'charge with card id and return transaction entity' do
        VCR.use_cassette "payline charge with card id" do
          params = {
            customer_id: '1521341724',
            amount:      10,
          }
          result = merchant.execute(
            params:     params,
            action:     'charge_customer_with_card_id',
            credential: @credential
          )
          expect(result.customer_id).to eq('1521341724')
          expect(result.transaction_id).to eq('3972855846')
          expect(result.merchant).to eq('payline')
          expect(result.created_at).not_to eq nil
        end
      end

      it 'return declined when charge' do
        VCR.use_cassette "payline return declined with charge" do
          params = {
            customer_id: '1521341724',
            amount:      0.5,
          }
          result = merchant.execute(
            params:     params,
            action:     'charge_customer_with_card_id',
            credential: @credential
          )
          expect(result.customer_id).to eq('1521341724')
          expect(result.transaction_id).to eq('3972857009')
          expect(result.merchant).to eq('payline')
          expect(result.response_text).to eq('DECLINE')
          expect(result.status).to eq('declined')
        end
      end
    end

    context 'refund' do
      it 'refund successfuly' do
        VCR.use_cassette "payline refund success" do
          params = {
            transaction_id: '3972855846',
            amount:      10,
          }
          result = merchant.execute(
            params:     params,
            action:     'refund',
            credential: @credential
          )
          expect(result.transaction_id).to eq('3972859117')
          expect(result.merchant).to eq('payline')
          expect(result.response_text).to eq('SUCCESS')
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
          customer_id: 667749310,
        }
      end

      it 'add card successfuly' do
        VCR.use_cassette "payline add card success" do
          result = merchant.execute(
            params:     params,
            action:     'add_card_to_existing_client',
            credential: @credential
          )
          expect(result.card_id).to eq('274098849')
          expect(result.customer_id).to eq('667749310')
          expect(result.merchant).to eq('payline')
          expect(result.response_text).to eq('Customer Update Successful')
        end
      end

      it 'return error' do
        params[:card_number] = '111111'
        VCR.use_cassette "payline add card by using wrong card_number" do
          expect{merchant.execute(
            params:     params,
            action:     'add_card_to_existing_client',
            credential: @credential
          )}.to raise_error(PaymentApi::MerchantError, 'Invalid Credit Card Number REFID:3506288785')
        end
      end
    end

  end # end payline
end
