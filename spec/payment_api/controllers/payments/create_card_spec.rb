RSpec.describe PaymentApi::Controllers::Payments::CreateCard, type: :action do
  describe 'payline' do
    let(:params) { Hash[
      customer_id: 283841782,
      is_type:     'payline',
      card_number: '100000',
      card_month:  '10',
      card_year:   '2020',
      card_cvc:    '202',
      first_name:  'first_name',
      last_name:   'last_name',
      address:     'address',
      city:        'address',
      state:       'address',
      zip:         'address',
    ] }

    it 'create a void successful' do
      command = double('command', call: Dry::Monads::Either::Right.new(double('void', to_hash: {})))
      action = described_class.new(command: command)
      response = action.call(params)
      expect(response).to be_success
    end
  end
end
