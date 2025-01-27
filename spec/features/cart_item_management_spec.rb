require 'rails_helper'

RSpec.feature 'CartItem Management', type: :feature do
  let!(:admin_user) { create(:admin_user) }
  let!(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user) }
  let!(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

  before do
    # Admin login
    visit new_admin_user_session_path
    fill_in 'admin_user_email', with: admin_user.email
    fill_in 'admin_user_password', with: admin_user.password
    click_button 'Login'
  end

  scenario 'Admin can create a new cart item' do
    visit new_admin_cart_item_path

    select product.name, from: 'cart_item_product_id'
    fill_in 'cart_item_quantity', with: 2

    # Match the dropdown option format: "Cart #<id> for <user.email>"
    select "Cart ##{cart.id} for #{user.email}", from: 'cart_item_cart_id'

    click_button 'Create Cart item'

    expect(page).to have_content('Cart item was successfully created.')
    expect(CartItem.last.quantity).to eq(2)
  end

  scenario 'Admin can edit an existing cart item' do
    visit edit_admin_cart_item_path(cart_item)

    fill_in 'cart_item_quantity', with: 5
    click_button 'Update Cart item'

    expect(page).to have_content('Cart item was successfully updated.')
    expect(cart_item.reload.quantity).to eq(5)
  end

  scenario 'Admin can delete a cart item' do
    visit admin_cart_items_path

    expect(page).to have_content(cart_item.product.name)

    within("#cart_item_#{cart_item.id}") do
      accept_confirm { click_link 'Delete' }
    end

    expect(page).to have_content('Cart item was successfully destroyed.')
    expect(CartItem.exists?(cart_item.id)).to be_falsey
  end
end
