# frozen_string_literal: true

module Ffe
  class Engine < ::Rails::Engine
    isolate_namespace Ffe

    config.ffe = Ffe::Configuration.new
  end
end
