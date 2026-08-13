# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ffe::Configuration do
  describe 'sets defaults' do
    specify do
      config = described_class.new

      expect(config.enabled).to be(false)
      expect(config.milieus).to eq({ development: 0, testing: 1, staging: 2, production: 3 })
      expect(config.env_variable).to eq('RAILS_ENV')
    end
  end
end
