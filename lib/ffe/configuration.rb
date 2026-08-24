# frozen_string_literal: true

module Ffe
  class Configuration
    attr_accessor :bitlength, :env_variable, :milieus, :queue_adapter

    def initialize
      @bitlength = 4
      @env_variable = 'RAILS_ENV'
      @milieus = { development: 0, staging: 1, production: 2 }
      @queue_adapter = :async
    end
  end
end
