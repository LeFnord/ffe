# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require_relative 'dummy/config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'factory_bot_rails'

FactoryBot.definition_file_paths = [File.expand_path('factories', __dir__)]
FactoryBot.find_definitions

ActiveRecord::Migrator.migrations_paths = [File.expand_path('../db/migrate', __dir__)]
ActiveRecord::Migration.maintain_test_schema!

support_files = Dir[File.expand_path('support/**/*.rb', __dir__)]
support_files.sort.each { |file| require file }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
end
