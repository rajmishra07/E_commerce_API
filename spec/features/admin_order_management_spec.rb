require 'rails_helper'

RSpec.feature "Orders Management", type: :feature do
  let!(:admin_user) { create(:admin_user) }
  let!(:users) { create_list(:user, 2) }
  let!(:order) { create(:order, user: users.first) }
  let!(:product) { create(:product) } 

  before do
    visit new_admin_user_session_path
    fill_in 'Email', with: admin_user.email
    fill_in 'Password', with: admin_user.password
    click_button 'Login'
  end

  scenario "Admin views list of orders" do
    visit admin_orders_path

    expect(page).to have_content(order.id)
    expect(page).to have_content(order.status)
    expect(page).to have_content(order.user.email)
  end

  scenario "Admin creates a new order" do
    visit new_admin_order_path

    
    expect(page).to have_select('order_user_id', with_options: ['Select a User', *User.all.pluck(:email)])

    
    select users.first.email, from: 'order_user_id'
    select 'pending', from: 'order_status'

    click_button 'Create Order'

    
    expect(page).to have_content('Order was successfully created.')
    expect(page).to have_content(users.first.email)
    expect(page).to have_content('pending')
  end

  scenario "Admin deletes an order" do
    visit admin_orders_path

   
    expect {
      click_link "Delete", href: admin_order_path(order)
      page.driver.browser.switch_to.alert.accept
      sleep 1 # Wait for the deletion to process
    }.to change(Order, :count).by(-1)

    
    expect(page).to have_content('Order was successfully destroyed.')
  end
end