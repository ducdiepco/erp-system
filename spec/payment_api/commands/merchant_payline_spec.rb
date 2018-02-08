RSpec.describe PaymentApi::Commands::Merchant, type: :command do
  let(:command) { described_class.new }
  describe '#call' do
    before do
      Fabricate.create(:payline_merchant, is_type: 'payline-1')
    end

    context 'with action: create_customer_and_add_card ' do
      let(:params) { Hash[
        is_type:     'payline-1',
        card_number: 4111111111111111,
        card_month:  10,
        card_year:   2020,
        card_cvc:    123,
        first_name:  'test_first_name',
        last_name:   'test_last_name',
        email:       'email@email.com',
      ] }
      let(:action) { 'create_customer_and_add_card' }

      it 'is successful' do
        VCR.use_cassette "payline create customer with card - command" do
          response = command.call(params, action)
          expect(response.success?).to eq true
          data = response.value
          expect(data.customer_id).to eq '434998374'
          expect(data.merchant).to eq 'payline-1'
        end
      end

      it 'return error' do
        params[:card_number] = 3483833838
        VCR.use_cassette "payline create customer with wrong card - command" do
          response = command.call(params, action)
          expect(response.failure?).to eq true
          expect(response.value.message).to eq 'Invalid Credit Card Number REFID:3505905846'
        end
      end
    end

    context 'with action: charge_customer_with_card_id ' do
      let(:params) { Hash[
        is_type:     'payline-1',
        amount:      10,
        customer_id: 283841782,
      ] }
      let(:action) { 'charge_customer_with_card_id' }

      it 'is successful' do
        VCR.use_cassette "payline charge customer by using card_id - command" do
          response = command.call(params, action)
          expect(response.success?).to eq true
          data = response.value
          expect(data.transaction_id).to eq '3979704279'
        end
      end

      it 'return error' do
        params[:customer_id] = 1111111
        VCR.use_cassette "payline charge customer by using wrong customer_id - command" do
          response = command.call(params, action)
          expect(response.failure?).to eq true
          expect(response.value.message).to eq 'Invalid Customer Vault ID specified REFID:3506165921'
        end
      end
    end

    context 'with action: refund ' do
      let(:params) { Hash[
        is_type:        'payline-1',
        amount:         10,
        transaction_id: 3979752005,
      ] }
      let(:action) { 'refund' }

      it 'is successful' do
        VCR.use_cassette "payline refund by using transaction_id - command" do
          response = command.call(params, action)
          expect(response.success?).to eq true
          data = response.value
          expect(data.transaction_id).to eq '3980641170'
        end
      end

      it 'return error' do
        params[:amount] = 10
        VCR.use_cassette "payline refund exceed the transaction balance - command" do
          response = command.call(params, action)
          expect(response.failure?).to eq true
          expect(response.value.message).to eq 'Refund amount may not exceed the transaction balance REFID:3506214938'
        end
      end
    end

  end
end
