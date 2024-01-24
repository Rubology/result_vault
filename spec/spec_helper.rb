# frozen_string_literal: true

require_relative '../lib/result_vault'

# ======================================================================
# = SimpleCov
# ======================================================================

# Only calculate coverage when Simplecov is intsalled
begin
  puts "\nInitializing simplecov"
  require 'simplecov'

  # set output to Coberatura XML if using Testspace analysis
  if ENV['FOR_TESTSPACE']
    require 'simplecov-cobertura'
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end

  # start it up
  SimpleCov.start
rescue StandardError
  # nothing to do here
end

# ======================================================================
# = RSpec Config
# ======================================================================

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
