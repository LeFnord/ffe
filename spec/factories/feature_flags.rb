# frozen_string_literal: true

FactoryBot.define do
  factory :feature_flag, class: 'Ffe::FeatureFlag' do
    name { 'dumme_flag' }
    enabled { false }
    expires_at { 1.week.from_now }
  end
end
