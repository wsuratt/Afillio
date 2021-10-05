# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'products', type: :system do
  scenario 'view products' do
    visit products_path
    expect(page).to have_text('Products')
  end
end