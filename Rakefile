# frozen_string_literal: true

require "bundler/gem_tasks"
require "./ruby_version"
ENV["BUNDLE_GEMFILE"] = RubyVersion.gemfile

require "bundler/setup"
require "minitest/test_task"

Minitest::TestTask.create(:test) do |t|
  t.warning = false
  t.test_globs = ["test/**/*_test.rb"]
  t.test_prelude = %(require File.expand_path("test/test_helper", Dir.pwd))
end

task :default => :test


desc "Installs gems using the correct gemfile for the current version of ruby."
task :bundle do
  puts "Installing from '#{RubyVersion.gemfile}'"
  system("bundle install --gemfile=#{RubyVersion.gemfile}")
  system("bundle lock --add-platform x86_64-linux --gemfile=#{RubyVersion.gemfile}")
end



desc "Runs bundle outdated for the current version of ruby."
task :outdated do
  puts "Checking outdated for '#{RubyVersion.gemfile}'"
  system("BUNDLE_GEMFILE=#{RubyVersion.gemfile} bundle outdated")
end



desc "Runs bundle update for the current version of ruby."
task :update do
  puts "Updating for '#{RubyVersion.gemfile}'"
  system("BUNDLE_GEMFILE=#{RubyVersion.gemfile} bundle update")
end



desc "Runs bundle info <gem> for the current version of ruby."
task :info do
  system("BUNDLE_GEMFILE=#{RubyVersion.gemfile} bundle info #{ARGV[1]}")
  exit 0
end
