# frozen_string_literal: true

module Ffe
  class Configuration
    attr_accessor :bitlength, :env_variable, :milieus

    def initialize
      @bitlength = 4
      @env_variable = 'RAILS_ENV'
      @milieus = { development: 0, staging: 1, production: 2 }
    end
  end
end
