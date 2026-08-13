# frozen_string_literal: true

FactoryBot.define do
  factory :ffe, class: 'Ffe::Ffe' do
    name { 'dumme_flag' }
    enabled { false }
    expires_at { 1.week.from_now }
  end
end
