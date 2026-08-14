# frozen_string_literal: true

module Ffe
  class Configuration
    attr_accessor :milieus, :env_variable

    def initialize
      @milieus = { development: 0, staging: 1, production: 2 }
      @env_variable = 'RAILS_ENV'
    end
  end
end
