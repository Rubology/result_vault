RSpec.describe ResultVault, type: :model do

  describe 'getter methods' do
    let(:result) { ResultVault.new(test_1: 'One', test_2: 'Two') }

    %i[success ok good pass passed succeeded].each do |name|
      context ":#{name}" do
        it 'returns the value of :success?' do
          res = ResultVault.new(success: true)
          expect(res.send("#{name}?")).to be_truthy
        end
      end
    end # each name

    describe ':data' do
      it 'returns a hash of the result data' do
        expect(result.data).to be_a Hash
        expect(result.data.keys).to include :test_1
        expect(result.data.keys).to include :test_2
        expect(result.data[:test_1]).to eq 'One'
        expect(result.data[:test_2]).to eq 'Two'
      end

      it 'freezes the returned hash' do
        expect(result.data).to be_frozen
      end
    end # ":data"

    describe ':status' do
      it 'returns the status' do
        expect(result.status).to be_nil
        result.status = :test_status
        expect(result.status).to eq :test_status
      end
    end # :status

    describe ':exception' do
      it 'returns the exception value' do
        result.exception = ArgumentError.new
        expect(result.exception).to be_a Exception
      end
    end # :exception

    describe ':error_message' do
      it 'returns the error message' do
        expect(result.error_message).to be_empty
        result.error_message = 'Test Message'
        expect(result.error_message).to eq 'Test Message'
      end
    end # :error_message
  end
end
