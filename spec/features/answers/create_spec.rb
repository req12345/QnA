require 'rails_helper'

feature 'User can create answer', %q{
  In order to help a man
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers question', js: true  do
      fill_in 'Body', with: 'text text text'
      click_on 'Answer'

      expect(page).to have_content 'text text text'
    end

    scenario 'answers a question with errors', js: true do

      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user can't create answer" do
    visit question_path(question)

    expect(page).to_not have_content 'Create new answer'
  end
end
