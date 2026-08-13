# frozen_string_literal: true

module Ffe
  class Ffe < ApplicationRecord
    self.table_name = 'ffes'

    validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z_]+\z/ }
    validates :expires_at, comparison: { greater_than: Time.current.end_of_day }, if: -> { expires_at.present? }
  end
end
