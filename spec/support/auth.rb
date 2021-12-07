# frozen_string_literal: true

module AuthHelpers
  module System
    def sign_in(user)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'testtest'
      click_button 'Log in'
      expect(page).to_not have_text('Log in', wait: 10)
    end

    def sign_out
      click_button user.username
      click_button 'Sign out'
      expect(page).to have_text('Log in', wait: 10)
    end
  end

  module Request
    def sign_in(user)
      post session_url, params: { email: user.email, password: 'testtest' }
    end
  end
end

RSpec.configure do |config|
  config.include AuthHelpers::System, type: :system
  config.include AuthHelpers::Request, type: :request
end
