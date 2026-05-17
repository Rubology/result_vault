
class SetterMethodsTest < MinitestBase

  describe 'setter method' do
    before { @result = ResultVault.new(test_1: 'One', test_2: 'Two') }

    %i[success ok good pass passed succeeded].each do |name|
      context ":#{name}=" do
        it ':sets the value of :success?' do
          refute @result.success?
          @result.send("#{name}=", true)
          assert @result.success?
        end
      end
    end # each name

    describe ':data=' do
      it 'raises an exception when called' do
        error = assert_raises ArgumentError do
          @result.data = { test_1: 'tester' }
        end
        
        assert_includes error.message, 'use :update to set or update results.'
      end
    end # :data=

    describe ":update" do
      it 'adds new arguments' do
        assert @result.update(tester: 'Bill', tester2: 'Ben')
        assert_equal 'Bill', @result.tester
        assert_equal 'Ben', @result.tester2
      end

      it 'updates existing arguments' do
        refute @result.success?
        refute @result.passed?
        @result.update(passed: true)
        assert @result.passed?
        assert @result.success?
      end

      it 'makes no change if no arguments given' do
        data = @result.data
        assert_equal @result, @result.update
        assert_equal data, @result.data
      end

      it 'returns itself if successful' do
        response = @result.update(test_1: 'Three')
        assert_equal @result, response
      end

      it 'downcases all keys' do
        @result.update(:Test_3 => 'Three', :tesT_4 => 4)
        refute_includes @result.data.keys, :Test_3
        assert_includes @result.data.keys, :test_3
        refute_includes @result.data.keys, :tesT_4
        assert_includes @result.data.keys, :test_4

        assert_equal 'Three', @result.test_3
        assert_equal 4, @result.test_4
      end

      it "raises an exception with a non-Symbol key" do
        error = assert_raises ArgumentError do
          @result.update('test_5' => 5)
        end
        
        assert_includes error.message, ':update argument key not a Symbol: \'test_5\'.'
      end
    end # :update

    describe ':status=' do
      it 'sets the status' do
        assert_nil @result.status
        @result.status = :test_status
        assert_equal :test_status, @result.status
      end
    end # :status=

    describe ':exception=' do
      it 'raises an exception when the value is not an Exception' do
        error = assert_raises ArgumentError do
          @result.exception = 'My error message'
        end
        
        assert_includes error.message, "accept an Exception instance"
      end

      it 'sets the exception value' do
        assert @result.exception = ArgumentError.new
      end

      it 'updates the error message if blank' do
        @result.exception = ArgumentError.new
        assert @result.exception.to_s, @result.error_message
      end

      it 'leaves an existing error message unchanged' do
        @result.error_message = 'Test message'
        @result.exception = ArgumentError.new
        assert_equal 'Test message', @result.error_message
      end
    end # :exception=

    describe ':error_message=' do
      it 'sets the error message' do
        assert_empty @result.error_message
        @result.error_message = 'Test Message'
        assert_equal 'Test Message', @result.error_message
      end
    end # :error_message=
  end # setter method
end
