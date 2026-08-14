# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'Ffe::User' do
    name { 'MyString' }
    email { 'some@dummy.dd' }
  end
end
