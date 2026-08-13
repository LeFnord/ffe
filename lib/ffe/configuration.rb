# frozen_string_literal: true

module Ffe
  class Configuration
    attr_accessor :enabled, :milieus, :env_variable

    def initialize
      @enabled = false
      @milieus = { development: 0, testing: 1, staging: 2, production: 3 }
      @env_variable = 'RAILS_ENV'
    end
  end
end
