# frozen_string_literal: true

module Ffe
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
