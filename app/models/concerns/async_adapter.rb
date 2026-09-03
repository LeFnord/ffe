# frozen_string_literal: true

module AsyncAdapter
  extend ActiveSupport::Concern

  def adapter_job # rubocop:disable Naming/PredicateMethod
    false
  end
end
