# frozen_string_literal: true

require 'rails/generators'

module Ffe
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)

      desc 'Creates an initializer for the Ffe engine'

      def copy_initializer
        template 'ffe_initializer.rb.tt', 'config/initializers/ffe.rb'
        template 'feature_flags.json.tt', 'config/feature_flags.json'
      end
    end
  end
end
