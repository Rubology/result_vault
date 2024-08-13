RSpec.describe ResultVault, type: :model do

  describe 'meta methods' do
    let(:result) { ResultVault.new(test_1: 'One', test_2: 'Two') }

    describe ':methods' do
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
      end # :methods

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

    describe ':method_missing (private)' do
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
