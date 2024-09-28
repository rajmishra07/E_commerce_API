# spec/features/product_management_spec.rb

require 'rails_helper'

RSpec.feature 'Product Management', type: :feature do
  let!(:admin_user) { create(:admin_user) } # Assuming you have an admin user factory
  let!(:seller) { create(:user, role: 'seller') }
  let!(:product) { create(:product, user: seller) } # Product created by the seller

  before do
    # Sign in as admin before each test
    visit new_admin_user_session_path
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Login'
  end

  scenario 'Admin can create a new product' do
    visit new_admin_product_path  # Navigate to the product creation page

    fill_in 'product_name', with: 'New Product'
    fill_in 'product_description', with: 'Description of new product.'
    fill_in 'product_price', with: 20.00
    select seller.email, from: 'product_user_id' # Assuming user is a dropdown
    click_button 'Create Product'

    expect(page).to have_content('Product was successfully created.')  # Check for success message
    expect(Product.last.name).to eq('New Product')  # Validate new product creation
  end

  scenario 'Admin can edit an existing product' do
    visit edit_admin_product_path(product)  # Navigate to the product edit page

    fill_in 'product_name', with: 'Updated Product Name'
    fill_in 'product_description', with: 'Updated description.'
    fill_in 'product_price', with: 30.00
    select seller.email, from: 'product_user_id'
    click_button 'Update Product'

    expect(page).to have_content('Product was successfully updated.')  # Check for success message
    expect(product.reload.name).to eq('Updated Product Name')  # Validate product name update
  end

  scenario 'Admin can delete a product' do
    visit admin_products_path  # Navigate to the product index page

    expect(page).to have_content(product.name)  # Ensure the product is listed

    within("#product_#{product.id}") do  # Ensure each product row has an ID
      click_link 'Delete'
    end

    # Handle the confirmation alert
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content('Product was successfully destroyed.')  # Check for success message
    expect(page).not_to have_content(product.name)  # Validate product is no longer listed
  end
end