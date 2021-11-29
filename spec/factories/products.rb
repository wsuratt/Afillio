# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    title { 'Cool Product' }
    image { Rack::Test::UploadedFile.new('./spec/images/test_product.jpg') }
    description { 'This is a cool product.' }
    quantity { '10' }
    price { '19.99' }
    commission { '5' }
    user
  end
end
