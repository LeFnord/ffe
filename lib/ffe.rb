# frozen_string_literal: true

require 'ffe/version'
require 'ffe/configuration'
require 'ffe/engine'

module Ffe
  class << self
    def configure
      yield config
    end

    def config
      Rails.application.config.ffe
    end
  end
end
