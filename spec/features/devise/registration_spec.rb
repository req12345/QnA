require 'rails_helper'

feature 'User can sign out', %q{
  In order to ask and answers questions
  As an unregistered user
  Id like to be able to pass registration
} do

  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  scenario 'User enter valid parameters' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '1234567890'
    fill_in 'Password confirmation', with: '1234567890'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User enters passwords that do not match' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '11'
    fill_in 'Password confirmation', with: '11'
    click_on 'Sign up'

    expect(page).to have_content 'Password is too short'
  end

  scenario 'User enters too short password' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '1234567890'
    fill_in 'Password confirmation', with: '1234567809'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'User enters invalid email' do
    fill_in 'Email', with: 'user@'
    fill_in 'Password', with: '1234567890'
    fill_in 'Password confirmation', with: '1234567890'
    click_on 'Sign up'

    expect(page).to have_content 'Email is invalid'
  end

  scenario 'User enter email that already exists' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '1234567890'
    fill_in 'Password confirmation', with: '1234567890'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
