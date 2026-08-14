# frozen_string_literal: true

module Ffe
  class FeatureFlag < ApplicationRecord
    self.table_name = 'feature_flags'

    validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z_]+\z/ }
    validates :expires_at, comparison: { greater_than: Time.current.end_of_day }, if: -> { expires_at.present? }

    # the Flag functionality itself
    #
    # main methods
    def self.enabled?(flag)
      feature = find_by(name: flag)

      feature.enabled? && feature.allowed_milieu?
    end

    def self.disabled?(flag)
      !enabled?(flag)
    end

    def self.enabled_for?(flag, user: nil)
      return enabled?(flag) if user.blank?

      feature = find_by(name: flag)
      return false unless feature.allowed_milieu?

      feature.enabled? && feature.user_ids.include?(user.id.to_s)
    end

    # instance methods
    #
    def allowed_milieu?
      actual_milieu = ENV.fetch(Ffe.config.env_variable, false)
      return false unless actual_milieu

      pos = Ffe.config.milieus[actual_milieu.to_sym]
      milieu[pos] == '1'
    end
  end
end
