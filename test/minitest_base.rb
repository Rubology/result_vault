
class MinitestBase < Minitest::Test

  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)
  
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  
  # Enable spec-style DSL
  extend Minitest::Spec::DSL
  
  class << self
    alias context describe
  end
end
