RSpec.describe PaymentApi::Controllers::Payments::CreateRefund, type: :action do
  describe 'payline' do
    let(:params) { Hash[
      amount:      10,
      transaction_id: 283841782,
      is_type: 'payline',
    ] }

    it 'create a refund successful' do
      command = double('command', call: Dry::Monads::Either::Right.new(double('refund', to_hash: {})))
      action = described_class.new(command: command)
      response = action.call(params)
      expect(response).to be_success
    end
  end
end
