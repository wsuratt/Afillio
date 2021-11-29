# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'seller@test.com' }
    password { 'testtest' }
    confirmed_at { Time.now }

    after(:create) {|user| user.remove_role(:admin)}
    after(:create) {|user| user.add_role(:seller)}

    factory :vendor_user do
      vendor_title { 'Test Company' }
      support_email { 'support@test.com '}

      after(:create) {|user| user.remove_role(:seller)}
      after(:create) {|user| user.add_role(:vendor)}
    end

    factory :admin_user do
      after(:create) {|user| user.remove_role(:seller)}
      after(:create) {|user| user.add_role(:admin)}
    end
  end
end
