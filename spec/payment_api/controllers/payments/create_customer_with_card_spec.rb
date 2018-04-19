RSpec.describe PaymentApi::Controllers::Payments::CreateCustomerWithCard, type: :action do
  describe 'payline' do
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

    it 'return merchant not found error ' do
      command = double('command', call: Dry::Monads::Either::Left.new('merchant not found'))
      action = described_class.new(command: command )
      response = action.call(params)
      expect(response).to match_in_body '{\"message\":\"merchant not found\"}'
    end

    it 'return new customer' do
      command = double('command',
                       call: Dry::Monads::Either::Right.new(double('customer', to_hash: {})),
                      )
      action = described_class.new(command: command )
      response = action.call(params)
      expect(response).to be_success
    end

    it 'return error cause missing is_type' do
      params[:is_type] = ''
      action = described_class.new
      response = action.call(params)
      expect(response).to have_http_status(200)
      expect(response).to match_in_body '["{\"is_type\":[\"must be filled\"]}"]'
    end

  end
end
