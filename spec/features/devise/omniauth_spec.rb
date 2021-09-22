require 'rails_helper'

feature 'Authorization from providers', %q{
  In order to get access to all application possibilities
  As a user
  I want to be able to sign in by account from another app
} do

  given!(:user) { create(:user, email: 'new@user.com')}
  background { visit new_user_session_path }

  describe 'Github' do
    scenario 'user successfully signed in' do
      mock_auth_hash(:github, 'new@mail.ru')
      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end
  end

  describe 'Sign in with Vkontakte' do
    scenario 'successfully' do
      mock_auth_hash(:vkontakte, 'new@mail.ru')
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end

    scenario "provider doesn't have user's email" do
      mock_auth_hash(:vkontakte)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email'
      fill_in 'email', with: 'new@mail.ru'
      click_on 'Submit'

      open_email('new@mail.ru')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'user enters invalid email' do
      mock_auth_hash(:vkontakte)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email'
      fill_in 'email', with: 'wrong_email'
      click_on 'Submit'

      expect(page).to have_content 'Enter your email'
      expect(page).to have_selector("input[type=email][id='email']")
      expect(page).to have_selector("input[type=submit][value='Submit']")
    end
  end

end
