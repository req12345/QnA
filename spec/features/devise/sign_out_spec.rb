require 'rails_helper'

feature 'User can sign out', %q{
  In order to end the session
  As an signed in user
  Id like to be able to sign out
} do
  given(:user) { create(:user) }

  background { visit root_path }

  scenario 'Signed in user sign out' do
    sign_in(user)

    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Guest can not sign out' do
    expect(page).to_not have_content 'Log out'
  end
end
