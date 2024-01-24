# frozen_string_literal: true

require_relative 'lib/result_vault/version'

Gem::Specification.new do |spec|
  spec.name    = 'result_vault'
  spec.version = ResultVault::VERSION
  spec.summary = 'When your method needs to return more than a single value.'

  spec.description = %(
    When your method needs to return more than a single value,
    ResultVault is a pure ruby solution that lets you add all
    the extra bits you need while still returning a single object.
  ).gsub("\n", ' ')

  spec.authors = ['CodeMeister']
  spec.email   = ['result_vault@codemeister.dev']

  spec.homepage              = 'https://github.com/Rubology/result_vault'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = 'https://github.com/Rubology/result_vault/blob/master/CHANGELOG.md'

  spec.files         = Dir.glob('lib/**/*', File::FNM_DOTMATCH)
  spec.require_paths = ['lib']
end
