# frozen_string_literal: true

require_relative 'lib/ffe/version'

Gem::Specification.new do |spec|
  spec.name        = 'ffe'
  spec.version     = Ffe::VERSION
  spec.authors     = ['LeFnord']
  spec.email       = ['pscholz.le@gmail.com']
  spec.homepage    = 'https://github.com/LeFnord/ffe'
  spec.summary     = 'A minimal Feature Flag Engine for Rails'
  spec.description = 'A minimal Feature Flag Engine for Rails.'
  spec.license     = 'MIT'

  spec.required_ruby_version = Gem::Requirement.new('>= 4.0')

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '~> 8.0'
end
