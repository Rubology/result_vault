

RSpec.describe ResultVault, type: :model do

  # ======================================================================
  #  Initialize
  # ======================================================================

  describe 'on initialize' do
    context 'on success' do
      it 'sets default :success to false' do
        res = ResultVault.new(meth_1: :answer_1, meth_2: 'answer_2')
        expect(res.success?).to be_falsy
      end

      it 'sets default :exception to nil' do
        res = ResultVault.new(meth_1: :answer_1, meth_2: 'answer_2')
        expect(res.exception).to be_nil
      end

      it 'sets default :error_message to an empty string' do
        res = ResultVault.new(meth_1: :answer_1, meth_2: 'answer_2')
        expect(res.error_message).to eq ''
      end

      it 'records the data for each supplied parameter' do
        res = ResultVault.new(meth_1: :answer_1, meth_2: 'answer_2')
        expect(res.data[:meth_1]).to eq :answer_1
        expect(res.data[:meth_2]).to eq 'answer_2'
      end
    end # on success


    context 'key validation' do
      it 'raises an ArgumentError if the key is not a symbol' do
        expect{ResultVault.new('meth_1' => :answer_1)}.to raise_error ArgumentError, /Symbol/
      end

      it ':data raises a RuntimeError' do
        expect{ResultVault.new(data: {test_1: 'One'})}.to raise_error ArgumentError, /:data is a reserved keyword/
      end

      it ':exception raises an ArgumentError when the value is not an Exception' do
        expect{ResultVault.new(exception: 'test string')}.to raise_error ArgumentError, /Exception/
      end

      it ':exception sets the val when the value is an Exception' do
        res = ResultVault.new(exception: RuntimeError.new)
        expect(res.exception).to be_a RuntimeError
      end

      it ':success sets the success value' do
        res = ResultVault.new(success: true)
        expect(res.success?).to be_truthy
      end

      it ':ok sets the success value' do
        res = ResultVault.new(ok: true)
        expect(res.success?).to be_truthy
      end

      it ':good sets the success value' do
        res = ResultVault.new(good: true)
        expect(res.success?).to be_truthy
      end

      it ':pass sets the success value' do
        res = ResultVault.new(pass: true)
        expect(res.success?).to be_truthy
      end

      it ':passed sets the success value' do
        res = ResultVault.new(passed: true)
        expect(res.success?).to be_truthy
      end

      it ':succeeded sets the success value' do
        res = ResultVault.new(succeeded: true)
        expect(res.success?).to be_truthy
      end
    end # key validation
  end # on initialize

end
