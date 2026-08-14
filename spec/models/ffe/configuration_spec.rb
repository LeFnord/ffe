# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ffe::Configuration do
  describe 'sets defaults' do
    specify do
      config = described_class.new

      expect(config.milieus).to eq({ development: 0, staging: 1, production: 2 })
      expect(config.env_variable).to eq('RAILS_ENV')
    end
  end
end
