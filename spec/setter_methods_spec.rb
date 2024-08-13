RSpec.describe ResultVault, type: :model do

  describe 'setter methods' do
    let(:result) { ResultVault.new(test_1: 'One', test_2: 'Two') }

    %i[success ok good pass passed succeeded].each do |name|
      context ":#{name}=" do
        it ':sets the value of :success?' do
          expect(result.success?).to be_falsy
          result.send("#{name}=", true)
          expect(result.success?).to be_truthy
        end
      end
    end # each name

    describe ':data=' do
      it 'raises an exception when called' do
        expect do
          result.data = { test_1: 'tester' }
        end.to raise_error ArgumentError,
                           /use :update to set or update results./
      end
    end # :data=

    describe ":update" do
      it 'adds new arguments' do
        expect(result.update(tester: 'Bill', tester2: 'Ben')).to be_truthy
        expect(result.tester).to  eq 'Bill'
        expect(result.tester2).to eq 'Ben'
      end

      it 'updates existing arguments' do
        expect(result.success?).to be_falsy
        expect(result.passed?).to  be_falsy
        result.update(passed: true)
        expect(result.passed?).to  be_truthy
        expect(result.success?).to be_truthy
      end

      it 'makes no change if no arguments given' do
        data = result.data
        expect(result.update).to eq result
        expect(result.data).to   eq data
      end

      it 'returns itself if successful' do
        response = result.update(test_1: 'Three')
        expect(response).to eq result
      end

      it 'downcases all keys' do
        result.update(:Test_3 => 'Three', :tesT_4 => 4)
        expect(result.data.keys).not_to include :Test_3
        expect(result.data.keys).to     include :test_3
        expect(result.data.keys).not_to include :tesT_4
        expect(result.data.keys).to     include :test_4

        expect(result.test_3).to eq 'Three'
        expect(result.test_4).to eq 4
      end

      it "raises an exception with a non-Symbol key" do
        expect do
          result.update('test_5' => 5)
        end.to raise_error ArgumentError,
                           /:update argument key not a Symbol: 'test_5'./
      end
    end # :update

    describe ':status=' do
      it 'sets the status' do
        expect(result.status).to be_nil
        result.status = :test_status
        expect(result.status).to eq :test_status
      end
    end # :status=

    describe ':exception=' do
      it 'raises an exception when the value is not an Exception' do
        expect { result.exception = 'My error message' }.to raise_error ArgumentError, /accept an Exception instance/
      end

      it 'sets the exception value' do
        expect { result.exception = ArgumentError.new }.not_to raise_error
      end

      it 'updates the error message if blank' do
        result.exception = ArgumentError.new
        expect(result.error_message).to eq(result.exception.to_s)
      end

      it 'leaves an existing error message unchanged' do
        result.error_message = 'Test message'
        result.exception = ArgumentError.new
        expect(result.error_message).to eq('Test message')
      end
    end # :exception=

    describe ':error_message=' do
      it 'sets the error message' do
        expect(result.error_message).to be_empty
        result.error_message = 'Test Message'
        expect(result.error_message).to eq 'Test Message'
      end
    end # :error_message=

  end
end
