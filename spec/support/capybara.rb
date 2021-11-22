require 'capybara/rspec'

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.start
  end
end