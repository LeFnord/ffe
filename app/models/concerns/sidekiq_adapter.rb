# frozen_string_literal: true

module SidekiqAdapter
  extend ActiveSupport::Concern

  def adapter_job
    Sidekiq::ScheduledSet.new.find do |job|
      job.item.dig('args', 0, 'job_id') == job_id
    end
  end

  def adapter_update_job
    destroy_job
    create_job
  end

  def adapter_destroy_job
    job.presence&.delete
  end
end
