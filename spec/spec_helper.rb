# frozen_string_literal: true

# ======================================================================
# = SimpleCov
# ======================================================================
require 'simplecov'

SimpleCov.configure do
  # exclude tests
  add_filter 'spec'
end

# set auto-fail is less than 100% coverage
SimpleCov.minimum_coverage(100) if ENV['FAIL_ON_MINIMUM']

# start it up
SimpleCov.start

# require AFTER simpleCOv has started to ensure inclusion in metrics
require_relative '../lib/result_vault'

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
