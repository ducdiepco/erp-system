RSpec.describe PaymentApi::Controllers::Payments::CreateVoid, type: :action do
  describe 'payline' do
    let(:params) { Hash[
      transaction_id: 283841782,
      is_type: 'payline',
    ] }

    it 'create a void successful' do
      command = double('command', call: Dry::Monads::Either::Right.new(double('void', to_hash: {})))
      action = described_class.new(command: command)
      response = action.call(params)
      expect(response).to be_success
    end
  end
end
