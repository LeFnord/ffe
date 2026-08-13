# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ffes', type: :request do
  let!(:ffe) { create(:ffe, name: 'Alpha') }

  it 'lists ffes' do
    get '/ffe/ffes'

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Alpha')
  end

  it 'creates a ffe' do
    expect do
      post '/ffe/ffes', params: { ffe: attributes_for(:ffe, name: 'Beta') }
    end.to change(Ffe::Ffe, :count).by(1)

    expect(response).to redirect_to("/ffe/ffes/#{Ffe::Ffe.order(:created_at).last.id}")
  end

  it 'updates a ffe' do
    patch "/ffe/ffes/#{ffe.id}", params: { ffe: attributes_for(:ffe, name: 'Gamma') }

    expect(response).to redirect_to("/ffe/ffes/#{ffe.id}")
    expect(ffe.reload.name).to eq('Gamma')
  end

  it 'destroys a ffe' do
    expect do
      delete "/ffe/ffes/#{ffe.id}"
    end.to change(Ffe::Ffe, :count).by(-1)

    expect(response).to redirect_to('/ffe/ffes')
  end
end
