# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ffe::Ffe, type: :model do
  describe 'validations' do
    describe 'name format' do
      describe 'required' do
        subject { build(:ffe, name: nil) }
        it { is_expected.not_to be_valid }
      end

      describe 'valid' do
        subject { build(:ffe, name: 'dummy_of') }
        it { is_expected.to be_valid }
      end

      describe 'invalid' do
        subject { build(:ffe, name: 'dummy of') }
        it { is_expected.not_to be_valid }
      end
    end

    describe 'expires_at' do
      describe 'valid' do
        subject { build(:ffe, name: 'dummy_of', expires_at: Time.current.end_of_day + 1.hour) }
        it { is_expected.to be_valid }
      end

      describe 'invalid' do
        subject { build(:ffe, name: 'dummy_of', expires_at: Time.current.end_of_day) }
        it { is_expected.not_to be_valid }
      end
    end
  end
end
