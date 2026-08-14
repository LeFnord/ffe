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

    def readable_milieus # rubocop:disable Metrics/AbcSize
      relevant = milieu.to_s.ljust(Ffe.config.milieus.length, '0').chars.first(Ffe.config.milieus.length)
      return 'all' if relevant.all? { |m| m == '1' }
      return 'no' if relevant.all? { |m| m == '0' }

      inverted = Ffe.config.milieus.invert
      relevant.each_with_index.filter_map { |m, i| inverted[i] if m == '1' }.join(', ')
    end
  end
end
