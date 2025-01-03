# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "./ruby_version"

RSpec::Core::RakeTask.new(:spec)

task default: :spec


desc "Installs gems using the correct gemfile for the current version of ruby."
task :bundle do
  puts "Installing from '#{RubyVersion.gemfile}'"
  system("bundle --gemfile=#{RubyVersion.gemfile}")
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
