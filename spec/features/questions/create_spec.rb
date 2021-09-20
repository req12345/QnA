require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  context "muliple sessions" do
    scenario "question appears on other users page", js: true do
     Capybara.using_session('user') do
       sign_in(user)
       visit questions_path
     end

     Capybara.using_session('guest') do
       visit questions_path
     end

     Capybara.using_session('user') do
       click_on 'Ask question'
       fill_in 'Title', with: 'Test title'
       fill_in 'Body', with: 'Test body'
       click_on 'Ask'
       expect(page).to have_content 'Your question successfully created'
       expect(page).to have_content 'Test title'
     end
     Capybara.using_session('guest') do
       expect(page).to have_content 'Test title'
     end
   end
 end

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with reward' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      within '.reward' do
        fill_in 'Reward name', with: 'My reward'
        attach_file 'Image', "#{Rails.root}/app/assets/images/reward.png"
      end
      click_on 'Ask'
      expect(Question.last.reward).to eq Reward.last
    end

  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
