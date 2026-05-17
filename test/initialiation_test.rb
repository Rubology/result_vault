
class InitializationTest < MinitestBase

  describe 'on initialize' do
    context 'on success' do
      before { @result = ResultVault.new(meth_1: :answer_1, meth_2: 'answer_2') }
      
      it 'sets default :success to false' do
        refute @result.success?
      end

      it 'sets default :exception to nil' do
        assert_nil @result.exception
      end

      it 'sets default :error_message to an empty string' do
        assert_equal '',  @result.error_message
      end

      it 'records the data for each supplied parameter' do
        assert_equal :answer_1,  @result.data[:meth_1]
        assert_equal 'answer_2', @result.data[:meth_2]
      end
    end # on success

    context 'key validation' do
      it 'raises an ArgumentError if the key is not a symbol' do
        error = assert_raises ArgumentError do
          ResultVault.new('meth_1' => :answer_1)
        end
        
        assert_includes error.message, "Symbol"
      end

      it ':data raises a RuntimeError' do
        error = assert_raises ArgumentError do
          ResultVault.new data: { test_1: 'One' }
        end
        
        assert_includes error.message, ":data is a reserved keyword"
      end

      it ':exception raises an ArgumentError when the value is not an Exception' do
        error = assert_raises ArgumentError  do
          ResultVault.new(exception: 'test string')
        end
        
        assert_includes error.message, "Exception"
      end

      it ':exception sets the val when the value is an Exception' do
        assert_kind_of RuntimeError, ResultVault.new(exception: RuntimeError.new).exception
      end

      it ':success sets the success value' do
        assert ResultVault.new(success: true).success?
      end

      it ':ok sets the success value' do
        assert ResultVault.new(ok: true).success?
      end

      it ':good sets the success value' do
        assert ResultVault.new(good: true).success?
      end

      it ':pass sets the success value' do
        assert ResultVault.new(pass: true).success?
      end

      it ':passed sets the success value' do
        assert ResultVault.new(passed: true).success?
      end

      it ':succeeded sets the success value' do
        assert ResultVault.new(succeeded: true).success?
      end
    end # key validation
  end # on initialize
end
