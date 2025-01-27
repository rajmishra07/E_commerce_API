require 'rails_helper'

RSpec.feature 'Cart Management', type: :feature do
  let!(:admin_user) { create(:admin_user) }
  let!(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user) }  

  before do
    visit new_admin_user_session_path
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Login'
  end

  scenario 'Admin can create a new cart' do
    visit new_admin_cart_path
    expect(User.count).to be > 0
    select user.email, from: 'cart_user_id'
    click_button 'Create Cart'
    expect(page).to have_content('Cart was successfully created.')
    expect(Cart.last.user).to eq(user)
  end

  scenario 'Admin can delete a cart' do
    visit admin_carts_path  

    expect(page).to have_content(cart.id)

    within("tr#cart_#{cart.id}") do
      accept_confirm do
        find('a', text: 'Delete', match: :first).click  
      end
    end

    visit admin_carts_path  # Reload the carts page

    expect(page).not_to have_selector("tr#cart_#{cart.id}")  # Validate the cart row is no longer present
    expect(Cart.exists?(cart.id)).to be_falsey  # Ensure the cart is removed from the database
  end
end