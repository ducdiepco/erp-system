RSpec.describe MerchantRepository, type: :repository do
  let(:repo) { MerchantRepository.new }
  describe '#find_by_type' do
    before do
      Fabricate.create(:merchant, is_type: 'test')
    end

    it 'return merchant' do
      result = repo.find_by_type('test')
      expect(result.is_type).to eq 'test'
    end

    it 'return empty' do
      result = repo.find_by_type(nil)
      expect(result).to eq nil
    end
  end
end
