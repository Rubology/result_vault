
class GetterMethodsTest < MinitestBase

  describe 'meta method' do
    before { @result = ResultVault.new(test_1: 'One', test_2: 'Two') }

    describe ':methods' do
      it 'includes inherited methods' do
        assert_includes @result.methods, :singleton_methods
        assert_includes @result.methods, :==
      end

      it 'includes instance getter methods' do
        assert_includes @result.methods, :data
        assert_includes @result.methods, :success?
      end

      it 'includes data getter methods' do
        assert_includes @result.methods, :test_1
        assert_includes @result.methods, :test_2
      end

      context 'when not frozen' do
        it 'includes instance setter methods' do
          assert_includes @result.methods, :success=
          assert_includes @result.methods, :pass=
        end

        it 'includes data setter methods' do
          assert_includes @result.methods, :test_1=
          assert_includes @result.methods, :test_2=
        end
      end

      context 'when frozen' do
        it 'excludes instance setter methods' do
          @result.freeze
          assert @result.frozen?
          refute_includes @result.methods, :success=
          refute_includes @result.methods, :pass=
        end

        it 'excludes data setter methods' do
          @result.freeze
          assert @result.frozen?
          refute_includes @result.methods, :test_1=
          refute_includes @result.methods, :test_2=
        end
      end # :methods

      context 'singleton methods' do
        it 'excludes inherited methods' do
          refute_includes @result.methods(false), :singleton_methods
          refute_includes @result.methods(false), :acts_like?
        end

        it 'excludes instance getter methods' do
          refute_includes @result.methods(false), :data
          refute_includes @result.methods(false), :success?
        end

        it 'excludes instance setter methods' do
          refute_includes @result.methods(false), :success=
          refute_includes @result.methods(false), :exception=
        end

        it 'includes data getter methods' do
          assert_includes @result.methods(false), :test_1
          assert_includes @result.methods(false), :test_2
        end

        context 'when not frozen' do
          it 'includes data setter methods' do
            assert_includes @result.methods(false), :test_1=
            assert_includes @result.methods(false), :test_2=
          end
        end

        context 'when frozen' do
          it 'excludes data setter methods' do
            @result.freeze
            assert @result.frozen?
            refute_includes @result.methods, :test_1=
            refute_includes @result.methods, :test_2=
          end
        end
      end # with a value of false
    end # ":methods"

    describe ':respond_to?' do
      it 'returns true for an inherited method' do
        assert @result.respond_to?(:to_s)
      end

      it 'returns true for an instance method' do
        assert @result.respond_to?(:success=)
      end

      it 'returns true for an existing data key' do
        assert @result.respond_to?(:test_1)
      end

      it 'returns true for a new data key' do
        assert @result.respond_to?(:test_3=)
      end

      it 'returns false for a missing method' do
        refute @result.respond_to?(:test_3)
      end
    end # :respond_to?

    describe ':method_missing (private)' do
      it "updates the data if the argument end with an '='" do
        assert_raises(NoMethodError) { @result.test }
        @result.test = 'Tester'
        assert_equal 'Tester', @result.test
      end

      it 'retrieves the value from the data cache if it exists' do
        @result.test = 'Tester'
        assert_equal 'Tester', @result.test
      end

      it 'works as normal with any other missing method' do
        assert_raises(NoMethodError) { @result.test }
      end

      it 'works as normal with any other inherited method' do
        assert_includes @result.to_s, 'ResultVault:0x'
      end
    end
  end
end
