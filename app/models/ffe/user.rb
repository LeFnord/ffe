# frozen_string_literal: true

# only a dummy model, it will be expected,
# that the host app already has a users model and table
module Ffe
  class User < ApplicationRecord
    self.table_name = 'users'
  end
end
