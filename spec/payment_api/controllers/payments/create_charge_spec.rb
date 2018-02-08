RSpec.describe PaymentApi::Controllers::Payments::CreateCharge, type: :action do
  describe 'payline' do
    let(:params) { Hash[
      amount:      10,
      customer_id: 283841782,
      is_type: 'payline',
    ] }

    it 'create a charge successful' do
      command = double('command', call: Dry::Monads::Either::Right.new(double('charge', to_hash: {})))
      action = described_class.new(command: command)
      response = action.call(params)
      expect(response).to be_success
    end
  end

  describe 'authorizenet' do
    let(:params) { Hash[
      amount:      10,
      customer_id: 283841782,
      is_type: 'authorizenet',
      card_id: 'test_card_id',
    ] }

    it 'create a charge successful' do
      command = double('command', call: Dry::Monads::Either::Right.new(double('charge', to_hash: {})))
      action = described_class.new(command: command)
      response = action.call(params)
      expect(response).to be_success
    end
  end

end
