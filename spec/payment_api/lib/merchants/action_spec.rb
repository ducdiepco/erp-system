RSpec.describe Merchants::Action, type: :service do
  describe 'payline merchant' do
    before do
      @credential = double(
        'credential',
        is_type: 'payline',
        metadata: {
          'username': 'Isweep631',
          'password': '4aCtPCLoYhbBFVVEymLuXcKq'
        },
      )
      @params = {
        card_number: 4111111111111111,
        card_month: 10,
        card_year: 2020,
        card_cvc: 123,
        first_name: 'test_first_name',
        last_name: 'test_last_name',
        email: 'email@email.com',
      }
    end

    it 'success charge and return charge object' do
      VCR.use_cassette "payline create customer" do
        result = described_class.send(
          params: @params,
          action: 'create_customer',
          credential: @credential
        )
      end
      require 'pry'; binding.pry
    end

  end

end
