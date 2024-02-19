RSpec.describe ResultVault, type: :model do
  let(:result) { ResultVault.new(test_1: 'One', test_2: 'Two') }

  describe 'methods' do
    %i[success ok good pass passed succeeded].each do |name|
      context ":#{name}" do
        it 'returns the value of :success?' do
          res = ResultVault.new(success: true)
          expect(res.send("#{name}?")).to be_truthy
        end
      end

      context ":#{name}=" do
        it ':sets the value of :success?' do
          expect(result.success?).to be_falsy
          result.send("#{name}=", true)
          expect(result.success?).to be_truthy
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

    describe ':data=' do
      it 'raises an exception when called' do
        expect do
          result.data = { test_1: 'tester' }
        end.to raise_error ArgumentError,
                           /:data is a reserved keyword and may not be set directly./
      end
    end # :data=

    describe ':status' do
      it 'returns the status' do
        expect(result.status).to be_nil
        result.status = :test_status
        expect(result.status).to eq :test_status
      end
    end # :status

    describe ':status=' do
      it 'sets the status' do
        expect(result.status).to be_nil
        result.status = :test_status
        expect(result.status).to eq :test_status
      end
    end # :status=

    describe ':exception' do
      it 'returns the exception value' do
        result.exception = ArgumentError.new
        expect(result.exception).to be_a Exception
      end
    end # :exception

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

    describe ':error_message' do
      it 'returns the error message' do
        expect(result.error_message).to be_empty
        result.error_message = 'Test Message'
        expect(result.error_message).to eq 'Test Message'
      end
    end # :error_message

    describe ':error_message=' do
      it 'sets the error message' do
        expect(result.error_message).to be_empty
        result.error_message = 'Test Message'
        expect(result.error_message).to eq 'Test Message'
      end
    end # :error_message=

    describe ':methods' do
      context 'regular methods' do
        it 'includes inherited methods' do
          expect(result.methods).to include(:singleton_methods)
          expect(result.methods).to include(:==)
        end

        it 'includes instance getter methods' do
          expect(result.methods).to include(:data)
          expect(result.methods).to include(:success?)
        end

        it 'includes data getter methods' do
          expect(result.methods).to include(:test_1)
          expect(result.methods).to include(:test_2)
        end

        context 'when not frozen' do
          it 'includes instance setter methods' do
            expect(result.methods).to include(:success=)
            expect(result.methods).to include(:pass=)
          end

          it 'includes data setter methods' do
            expect(result.methods).to include(:test_1=)
            expect(result.methods).to include(:test_2=)
          end
        end

        context 'when frozen' do
          it 'excludes instance setter methods' do
            result.freeze
            expect(result).to be_frozen
            expect(result.methods).not_to include(:success=)
            expect(result.methods).not_to include(:pass=)
          end

          it 'excludes data setter methods' do
            result.freeze
            expect(result).to be_frozen
            expect(result.methods).not_to include(:test_1=)
            expect(result.methods).not_to include(:test_2=)
          end
        end
      end # by default

      context 'singleton methods' do
        it 'excludes inherited methods' do
          expect(result.methods(false)).not_to include(:singleton_methods)
          expect(result.methods(false)).not_to include(:acts_like?)
        end

        it 'excludes instance getter methods' do
          expect(result.methods(false)).not_to include(:data)
          expect(result.methods(false)).not_to include(:success?)
        end

        it 'excludes instance setter methods' do
          expect(result.methods(false)).not_to include(:success=)
          expect(result.methods(false)).not_to include(:exception=)
        end

        it 'includes data getter methods' do
          expect(result.methods(false)).to include(:test_1)
          expect(result.methods(false)).to include(:test_2)
        end

        context 'when not frozen' do
          it 'includes data setter methods' do
            expect(result.methods(false)).to include(:test_1=)
            expect(result.methods(false)).to include(:test_2=)
          end
        end

        context 'when frozen' do
          it 'excludes data setter methods' do
            result.freeze
            expect(result).to be_frozen
            expect(result.methods(false)).not_to include(:test_1=)
            expect(result.methods(false)).not_to include(:test_2=)
          end
        end
      end # with a value of false
    end # ":methods"

    describe ':respond_to?' do
      it 'returns true for an inherited method' do
        res = ResultVault.new(test_1: 'One', test_2: 'Two')
        expect(result.respond_to?(:to_s)).to be_truthy
      end

      it 'returns true for an instance method' do
        res = ResultVault.new(test_1: 'One', test_2: 'Two')
        expect(result.respond_to?(:success=)).to be_truthy
      end

      it 'returns true for an existing data key' do
        res = ResultVault.new(test_1: 'One', test_2: 'Two')
        expect(result.respond_to?(:test_1)).to be_truthy
      end

      it 'returns true for a new data key' do
        res = ResultVault.new(test_1: 'One', test_2: 'Two')
        expect(result.respond_to?(:test_3=)).to be_truthy
      end

      it 'returns false for a missing method' do
        res = ResultVault.new(test_1: 'One', test_2: 'Two')
        expect(result.respond_to?(:test_3)).to be_falsy
      end
    end # :respond_to?
  end # methods

  describe 'missing methods' do
    context ':method_missing (private)' do
      it "updates the data if the argument end with an '='" do
        expect { result.test }.to raise_error NoMethodError
        result.test = 'Tester'
        expect(result.test).to eq 'Tester'
      end

      it 'retrieves the value from the data cache if it exists' do
        result.test = 'Tester'
        expect(result.test).to eq 'Tester'
      end

      it 'works as normal with any other missing method' do
        expect { result.test }.to raise_error NoMethodError
      end

      it 'works as normal with any other inherited method' do
        expect(result.to_s).to include('ResultVault:0x')
      end
    end
  end
end
