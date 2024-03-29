# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'products', type: :system do
  let(:vendor_user) { create(:vendor_user) }
  let(:product) { create(:product, user: vendor_user) }

  context 'as a user' do
    scenario 'view products' do
      visit products_path
      expect(page).to have_text('Products')
    end
  end

  context 'as a vendor user' do
    before { sign_in vendor_user }

    scenario 'creates new product' do
      visit new_product_path

      expect(page).to have_text('New product')

      fill_in 'Title', with: 'Cool Product'
      attach_file('product_images_1', './spec/product_content/test_image.jpg')
      attach_file('product_videos', './spec/product_content/test_video.mp4')
      find('#product_description').set 'This is a cool product.'
      fill_in 'Call to action', with: 'Buy this'
      fill_in 'Quantity', with: '10'
      fill_in 'Price', with: '19.99'
      fill_in 'Sale price', with: '12.99'
      fill_in 'Commission', with: '5'
      click_button 'Create Product'

      expect(page).to have_text('Product was successfully created.')
    end

    scenario 'edits product' do
      visit product_path(product)

      expect(page).to have_text(product.title)

      click_link 'Edit'

      fill_in 'Title', with: 'Not Cool Product'
      find('#product_description').set 'This is not a cool product.'
      click_button 'Update Product'

      expect(page).to have_text('Product was successfully updated.')
    end

    scenario 'deletes product' do
      visit product_path(product)

      expect(page).to have_text(product.title)

      accept_alert do
        click_link 'Delete'
      end

      expect(page).to have_text('Product was successfully deleted.')
    end
  end
end
