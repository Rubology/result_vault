
class GetterMethodsTest < MinitestBase

  describe 'getter method' do
    before { @result =  ResultVault.new(test_1: 'One', test_2: 'Two') }

    %i[success ok good pass passed succeeded].each do |name|
      context ":#{name}" do
        it 'returns the value of :success?' do
          res = ResultVault.new(success: true)
          assert res.send("#{name}?")
        end
      end
    end # each
    
    describe ':data' do
      it 'returns a hash of the result data' do
        assert_kind_of Hash, @result.data
        assert_includes @result.data.keys, :test_1
        assert_includes @result.data.keys, :test_2
        assert_equal 'One', @result.data[:test_1]
        assert_equal 'Two', @result.data[:test_2]
      end

      it 'freezes the returned hash' do
        assert @result.data.frozen?
      end
    end # ":data"

    describe ':status' do
      it 'returns the status' do
        assert_nil @result.status
        @result.status = :test_status
        assert_equal :test_status, @result.status
      end
    end # :status

    describe ':exception' do
      it 'returns the exception value' do
        @result.exception = ArgumentError.new
        assert_kind_of Exception, @result.exception
      end
    end # :exception

    describe ':error_message' do
      it 'returns the error message' do
        assert_empty @result.error_message
        @result.error_message = 'Test Message'
        assert_equal 'Test Message', @result.error_message
      end
    end # :error_message
  end # getter methods
end
