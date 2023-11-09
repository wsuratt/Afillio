# frozen_string_literal: true

User.create!(email: 'admin@example.com', password: 'testtest', password_confirmation: 'testtest', confirmed_at: Time.now)
User.create!(email: 'vendor@example.com', password: 'testtest', password_confirmation: 'testtest', confirmed_at: Time.now)
User.create!(email: 'seller@example.com', password: 'testtest', password_confirmation: 'testtest', confirmed_at: Time.now)

image_data  = File.open(File.join(Rails.root,'app/assets/images/testing.jpg'))
video_data  = File.open(File.join(Rails.root,'app/assets/videos/testing.mp4'))

Product.create!([{
                  title: 'test product',
                  description: 'A test product is a device or tool used to verify the effectiveness or reliability of another product. Examples include dummy loads to test batteries and power supplies, test benches to evaluate electronics and machinery, and consumer product testing to ensure quality and safety.',
                  user_id: User.first.id,
                  category: 'Other',
                  quantity: Faker::Number.between(from: 100, to: 1000),
                  price: Faker::Number.between(from: 20, to: 50),
                  commission: Faker::Number.between(from: 5, to: 20),
                  show: true,
                  images: Array.new(1, image_data),
                  videos: Array.new(1, video_data)
                }])

