# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ffe::ExpiredHandlingJob, type: :job do
  describe 'uses the ffe queue' do
    it { expect(described_class.queue_name).to eq('ffe') }
  end

  describe 'can be enqueued with a feature flag name' do
    specify do
      expect do
        described_class.perform_later('dummy_flag')
      end.to have_enqueued_job(described_class).with('dummy_flag').on_queue('ffe')
    end
  end

  it 'disables the matching feature flag' do
    feature_flag = create(:feature_flag, name: 'expired_flag', enabled: true)

    described_class.perform_now('expired_flag')

    expect(feature_flag.reload.enabled).to be(false)
  end
end
