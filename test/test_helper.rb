
require "minitest"

# ======================================================================
# = Header
# ======================================================================

##
# Don't show if testing via RubyMine
#
unless ENV['RM_INFO'] || ENV['TEAMCITY_VERSION']
  puts "\n\nTestings with:"
  puts " - Ruby: #{RUBY_VERSION}"
  puts " - Gemfile: #{ENV['BUNDLE_GEMFILE']}"
  puts " - Minitest: #{Minitest::VERSION}\n\n"
end


# ======================================================================
# = SimpleCov
# ======================================================================

require 'simplecov'

SimpleCov.configure do
  # exclude tests
  add_filter 'test'

  # explicitly track lib files
  track_files 'lib/**/*.rb'
end

# set auto-fail is less than 100% coverage
SimpleCov.minimum_coverage(100) if ENV['FAIL_ON_MINIMUM']

# start it up (will use already-running Coverage)
# SimpleCov.command_name "rake test"
SimpleCov.start

# ======================================================================
# = Test Helper
# ======================================================================

require "minitest/autorun"
require "minitest/spec"
require File.expand_path("./minitest_base", __dir__)
require 'debug'

# require AFTER simpleCOv has started to ensure inclusion in metrics
require File.expand_path("../lib/result_vault", __dir__)
