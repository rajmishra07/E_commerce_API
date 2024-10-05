require 'rails_helper'

RSpec.feature "OrderItems Management", type: :feature do
  let!(:admin_user) { create(:admin_user) }
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:order) { create(:order, user: user) }
  let!(:order_item) { create(:order_item, order: order, product: product) }

  before do
    visit new_admin_user_session_path
    fill_in 'Email', with: admin_user.email
    fill_in 'Password', with: admin_user.password
    click_button 'Login'
  end

  scenario "Admin creates a new order item" do
    visit new_admin_order_item_path

    # Debugging output to ensure records exist
    puts "Order IDs: #{Order.pluck(:id)}"
    puts "Product IDs: #{Product.pluck(:id)}"

    # Select order and product using correct fields
    select order.id.to_s, from: 'order_item_order_id'
    select product.name, from: 'order_item_product_id'
    fill_in 'Quantity', with: 2
    click_button 'Create Order item'
    
    expect(page).to have_content('Order item was successfully created.')
  end

  scenario "Admin deletes an order item" do
    visit admin_order_items_path

    expect {
      find("a[href='#{admin_order_item_path(order_item)}']", text: 'Delete').click
      page.driver.browser.switch_to.alert.accept
      sleep 1
    }.to change(OrderItem, :count).by(-1)

    expect(page).to have_content('Order item was successfully destroyed.')
  end
end