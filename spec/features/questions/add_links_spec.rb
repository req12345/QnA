require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/req12345/939db9b546f87fdaa781cecd1ac93660' }
  given(:github_url) { 'https://github.com' }

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    within '.nested-fields' do
      fill_in 'Link name', with: 'Github'
      fill_in 'Url', with: github_url
    end
    click_on 'Ask'

    within '.question' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Github', href: github_url
    end
  end
end
