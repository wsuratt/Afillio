30.times do
  Product.create!([{
    title: Faker::Commerce.product_name,
    description: Faker::TvShows::FamilyGuy.quote
  }])
end