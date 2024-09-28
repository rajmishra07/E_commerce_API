# spec/features/user_management_spec.rb
require 'rails_helper'

RSpec.feature "User Management", type: :feature do
  let!(:admin_user) { create(:admin_user) }
  let!(:user) { create(:user, email: "test@example.com", role: "user") } # Ensure to set the role

  before do
    # Admin login
    visit new_admin_user_session_path
    fill_in 'admin_user[email]', with: admin_user.email
    fill_in 'admin_user[password]', with: admin_user.password
    click_button 'Login'
  end

  scenario "Admin can view the list of users" do
    visit admin_users_path

    expect(page).to have_content('Users') # Check if the page contains the 'Users' heading
    expect(page).to have_content(user.email) # Check if the user email is present
  end

  scenario "Admin can create a new user" do
    visit new_admin_user_path

    fill_in 'user[email]', with: 'new_user@example.com'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'

    # Debugging output for available role options
    role_select = find('select[name="user[role]"]')
    options = role_select.all('option').map(&:text)  # Correct way to get options
    puts "Available role options: #{options.join(', ')}"  # Output available options to console

    # Ensure the role options are available in the select box
    select 'user', from: 'user[role]' # Use lowercase to match the defined roles

    click_button 'Create User'

    expect(page).to have_content('User was successfully created.')
    expect(page).to have_content('new_user@example.com')
  end

  scenario "Admin can update an existing user" do
  visit edit_admin_user_path(user)

  # Fill in required fields
  fill_in 'user[email]', with: 'updated_user@example.com'
  fill_in 'user[password]', with: 'newpassword'  # Provide a new password
  fill_in 'user[password_confirmation]', with: 'newpassword'  # Confirm the new password

  # Debugging output for available role options
  role_select = find('select[name="user[role]"]')
  options = role_select.all('option').map(&:text)  # Correct way to get options
  puts "Available role options: #{options.join(', ')}"  # Output available options to console

  # Ensure the role options are available in the select box
  select 'admin', from: 'user[role]' # Use lowercase to match the defined roles

  click_button 'Update User'

  # Check for the actual success message
  expect(page).to have_content('User was successfully updated.') # Adjust this to match the actual success message
  expect(page).to have_content('updated_user@example.com')
end



  scenario "Admin can delete a user", js: true do
    visit admin_users_path

    accept_confirm do
      find("a[href='#{admin_user_path(user)}'][data-method='delete']").click
    end

    expect(page).to have_content('User was successfully destroyed.')
    expect(page).not_to have_content(user.email)
  end
end
