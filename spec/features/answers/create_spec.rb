require 'rails_helper'

feature 'User can create answer', %q{
  In order to help a man
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  context "muliple sessions" do
    scenario "answer appears on other users page", js: true do
      Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
      end

      Capybara.using_session('guest') do
      visit question_path(question)
      end

      Capybara.using_session('user') do
      fill_in 'Your answer', with: 'Test answer'
      click_on 'Answer'
      expect(page).to have_content 'Test answer'
      end
      Capybara.using_session('guest') do
      expect(page).to have_content 'Test answer'
      end
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers question', js: true  do
      fill_in 'Your answer', with: 'text text text'
      click_on 'Answer'

      expect(page).to have_content 'text text text'
    end

    scenario 'answers a question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers with attached files', js: true do
      fill_in 'Your answer', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario "Unauthenticated user can't create answer" do
    visit question_path(question)

    expect(page).to_not have_content 'Create new answer'
  end
end
