# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FeatureFlags', type: :request do
  let!(:feature_flag) { create(:feature_flag, name: 'Alpha') }

  specify 'lists ffes' do
    get '/ffe/feature_flags'

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Alpha')
  end

  specify 'creates a ffe' do
    expect do
      post '/ffe/feature_flags', params: { feature_flag: attributes_for(:feature_flag, name: 'Beta') }
    end.to change(Ffe::FeatureFlag, :count).by(1)

    expect(response).to redirect_to("/ffe/feature_flags/#{Ffe::FeatureFlag.order(:created_at).last.id}")
  end

  specify 'updates a ffe' do
    patch "/ffe/feature_flags/#{feature_flag.id}", params: { feature_flag: attributes_for(:feature_flag, name: 'Gamma') }

    expect(response).to redirect_to("/ffe/feature_flags/#{feature_flag.id}")
    expect(feature_flag.reload.name).to eq('Gamma')
  end

  specify 'destroys a ffe' do
    expect do
      delete "/ffe/feature_flags/#{feature_flag.id}"
    end.to change(Ffe::FeatureFlag, :count).by(-1)

    expect(response).to redirect_to('/ffe/feature_flags')
  end
end
