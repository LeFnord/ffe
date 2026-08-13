# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in ffe.gemspec.
gemspec

# Your gem is dependent on a prerelease version of Rails. Once you can lock this
# dependency down to a specific version, move it to your gemspec.
gem 'rails', github: 'rails/rails', branch: 'main'

gem 'puma' # https://github.com/puma/puma

gem 'pg'

gem 'propshaft'

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"
group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'factory_bot_rails'
  gem 'pry-byebug'                          # https://github.com/deivid-rodriguez/pry-byebug
  gem 'pry-rails'                           # https://github.com/rweng/pry-rails
  gem 'rspec-rails'                         # https://github.com/rspec/rspec-rails
  gem 'rubocop-rails'                       # https://github.com/rubocop-hq/rubocop-rails/
end
