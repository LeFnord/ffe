# frozen_string_literal: true

module Ffe
  class FeatureFlag < ApplicationRecord
    case Ffe.config.queue_adapter
    when :solid_queue
      include SolidQueueAdapter
    when :sidekiq
      include SidekiqAdapter
    else
      include AsyncAdapter
    end

    self.table_name = 'feature_flags'

    # validations
    #
    validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z_\d]+\z/ }
    validates :expires_at, comparison: { greater_than: Time.current.end_of_day }, if: -> { expires_at.present? && expires_at_changed? } # rubocop:disable Layout/LineLength

    # callbacks
    after_save_commit :handle_change_job, if: -> { %i[solid_queue sidekiq].include?(Ffe.config.queue_adapter) }
    before_destroy :destroy_job

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

    def readable_milieus
      relevant = milieu.to_s.ljust(Ffe.config.milieus.length, '0').chars.first(Ffe.config.milieus.length)
      return 'all' if relevant.all? { |m| m == '1' }
      return 'no' if relevant.all? { |m| m == '0' }

      inverted = Ffe.config.milieus.invert
      relevant.each_with_index.filter_map { |m, i| inverted[i] if m == '1' }.join(', ')
    end

    # ExpiresAt related methods
    #
    # handles changes and decide to update or to destroy the job
    def handle_change_job
      if expires_at.present? && job_id.blank?
        create_job
      elsif expires_at.present? && job_id.present?
        update_job
      elsif expires_at.blank? && job_id.present?
        destroy_job
      end
    end

    # 1. create job if expires_at set
    def create_job
      return if expires_at.blank?

      job = Ffe::ExpiredHandlingJob.set(wait_until: expires_at).perform_later(name)
      update_columns(job_id: job.job_id, touch: true) # rubocop:disable Rails/SkipsModelValidations
    end

    # 2. update job if expires_at changed
    def update_job
      return unless job_id.present? && expires_at.present?
      return create_job unless job

      adapter_update_job if job
    end

    # 3. delete job if expires_at changed to empty, or FF was destroyed
    def destroy_job
      return if job_id.blank?

      adapter_destroy_job if job

      update_columns(job_id: nil, touch: true) unless destroyed? # rubocop:disable Rails/SkipsModelValidations
    end

    def job
      adapter_job.presence
    end
  end
end
