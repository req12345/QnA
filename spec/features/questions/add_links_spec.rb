require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:valid_url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/req12345/939db9b546f87fdaa781cecd1ac93660' }
  given(:github_url) { 'https://github.com' }
  given(:invalid_url) { 'invalid.com' }

  describe 'User adds links', js: true do
    background {
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'My link'
    }

    scenario ' with valid url when asks question', js: true do
      fill_in 'Url', with: valid_url
      click_on 'add link'
      within '.nested-fields' do
        fill_in 'Link name', with: 'Github'
        fill_in 'Url', with: github_url
      end

      click_on 'Ask'
      within '.question' do
        expect(page).to have_link 'My link', href: valid_url
        expect(page).to have_link 'Github', href: github_url
      end
    end

    scenario 'with invalid url when asks question', js: true do
      fill_in 'Url', with: invalid_url

      click_on 'Ask'
      expect(page).to_not have_link 'My link', href: invalid_url
      expect(page).to have_content 'is not a valid URL'
    end

    scenario 'to gist when asks question', js: true do
      fill_in 'Url', with: gist_url
      click_on 'Ask'

      expect(page).to have_content 'GET /anything?name=Ivan&age=31&number=1 HTTP/1.1'
    end
  end
end
