User.create!(email: 'admin@example.com', password: 'admin@example.com', password_confirmation: 'admin@example.com')

30.times do
  Product.create!([{
    title: Faker::Commerce.product_name,
    description: Faker::TvShows::FamilyGuy.quote,
    user_id: User.first.id
  }])
end