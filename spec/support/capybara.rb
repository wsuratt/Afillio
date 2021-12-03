# frozen_string_literal: true

require 'capybara/rspec'

RSpec.configure do |config|
  config.before(:each) do
    driven_by :selenium_chrome_headless
    # driven_by :selenium_chrome
  end
end
