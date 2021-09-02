require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario "Not author tries to edit other user's answer" do
    sign_in(not_author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    context 'as author' do
      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit'
      end

      scenario 'edits his answer with errors', js: true do
        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'
          expect(page).to have_content(answer.body)
          expect(page).to have_selector 'textarea'
        end

        within '.answer-errors' do
          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'edits his answer', js: true do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end
  end
end
