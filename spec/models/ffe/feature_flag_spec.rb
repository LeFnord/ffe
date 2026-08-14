# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ffe::FeatureFlag, type: :model do
  before do
    Ffe.config.env_variable = 'APP_ENV'
    ENV['APP_ENV'] = 'development'
  end

  describe 'validations' do
    describe 'name format' do
      describe 'required' do
        subject { build(:feature_flag, name: nil) }
        it { is_expected.not_to be_valid }
      end

      describe 'valid' do
        subject { build(:feature_flag, name: 'dummy_of') }
        it { is_expected.to be_valid }
      end

      describe 'invalid' do
        subject { build(:feature_flag, name: 'dummy of') }
        it { is_expected.not_to be_valid }
      end
    end

    describe 'expires_at' do
      describe 'valid' do
        subject { build(:feature_flag, name: 'dummy_of', expires_at: Time.current.end_of_day + 1.hour) }
        it { is_expected.to be_valid }
      end

      describe 'invalid' do
        subject { build(:feature_flag, name: 'dummy_of', expires_at: Time.current.end_of_day) }
        it { is_expected.not_to be_valid }
      end
    end
  end

  describe 'defaults' do
    subject(:feature_flag) { Ffe::FeatureFlag.new(name: 'dummy') }

    specify do
      expect(feature_flag.enabled).to be_falsey
      expect(feature_flag.expires_at).to be_nil
      expect(feature_flag.milieu).to eql '0000'
    end
  end

  describe '.enabled?' do
    subject { described_class.enabled?(:dummy) }

    describe 'not enabled' do
      before do
        create(:feature_flag, name: 'dummy', enabled: false, milieu: '1000')
      end

      it { is_expected.to be_falsey }
    end

    describe 'enabled' do
      before do
        create(:feature_flag, name: 'dummy', enabled: true, milieu: '1000')
      end

      it { is_expected.to be_truthy }
    end
  end

  describe '.enabled_for?' do
    describe 'no user given falls back to .enabled?' do
      subject { described_class.enabled_for?(:dummy) }

      before do
        create(:feature_flag, name: 'dummy', enabled: true, milieu: '1000')
      end

      it { is_expected.to be_truthy }
    end

    describe 'user given' do
      let(:user) { create(:user) }
      subject { described_class.enabled_for?(:dummy, user: user) }

      describe 'user allowed and enabled' do
        before do
          user
          create(:feature_flag, name: 'dummy', enabled: true, user_ids: [user.id, 23, 47])
        end

        it { is_expected.to be_truthy }
      end

      describe 'user allowed but not enabled' do
        before do
          user
          create(:feature_flag, name: 'dummy', enabled: false, user_ids: [user.id, 23, 47])
        end

        it { is_expected.to be_falsey }
      end

      describe 'user not allowed' do
        before do
          user
          create(:feature_flag, name: 'dummy', enabled: true, user_ids: [13, 23, 47])
        end

        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#allowed_milieu?' do
    subject { feature_flag.allowed_milieu? }

    describe 'not allowed' do
      let(:feature_flag) { create(:feature_flag, name: 'dummy_of', milieu: '0000') }

      it { is_expected.to be_falsey }
    end

    describe 'allowed' do
      let(:feature_flag) { create(:feature_flag, name: 'dummy_of', milieu: '1000') }

      it { is_expected.to be_truthy }
    end
  end
end
