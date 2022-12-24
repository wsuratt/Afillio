# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    title { 'Cool Product' }
    description { 'This is a cool product.' }
    cta { 'Buy this' }
    quantity { '10' }
    price { '19.99' }
    commission { '5' }
    user

    after(:build) do |product|
      product.images.attach(
        io: File.open(Rails.root.join('./spec/product_content/test_image.jpg')),
        filename: 'test_image.jpg',
        content_type: 'image/jpeg'
      )

      product.videos.attach(
        io: File.open(Rails.root.join('./spec/product_content/test_video.mp4')),
        filename: 'test_video.mp4',
        content_type: 'video/mp4'
      )
    end
  end
end
