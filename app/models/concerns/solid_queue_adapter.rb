# frozen_string_literal: true

module SolidQueueAdapter
  extend ActiveSupport::Concern

  def adapter_job
    SolidQueue::Job.scheduled.find_by(active_job_id: job_id)
  end

  def adapter_update_job
    job.update(scheduled_at: expires_at)
    se = SolidQueue::ScheduledExecution.find_by(job_id: job.id)
    se.update(scheduled_at: expires_at)
  end

  def adapter_destroy_job
    job.presence&.discard
  end
end
