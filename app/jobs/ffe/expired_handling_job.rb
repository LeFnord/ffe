# frozen_string_literal: true

module Ffe
  class ExpiredHandlingJob < ApplicationJob
    queue_as :ffe

    def perform(flag)
      feature_flag = FeatureFlag.find_by(name: flag)
      feature_flag.update!(enabled: false)
    end
  end
end
