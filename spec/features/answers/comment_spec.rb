require 'rails_helper'

feature 'User can add comments to answer', %q{
  In order to explain or asks something else about answer
  As an authenticated user
  I'd like to be able to add comments
} do
    given(:user) { create(:user) }
    given(:question) { create(:question, author: user) }
    given!(:answer) { create(:answer, question: question, author: user) }

    it "User add comment to answer", js: true do
      sign_in(user)
      visit question_path(question)
      within ".new-answer-comment" do
        fill_in 'Your comment', with: 'New comment'
        click_on 'Add comment'
      end
      expect(page).to have_content('New comment')
    end

    it 'Guest can not add comment', js: true do
      visit question_path(question)
      within "#answer-#{answer.id}" do
        expect(page).to_not have_button 'Add comment'
      end
    end

    context "muliple sessions" do
      scenario "comment appears on other users page", js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end
        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within ".new-answer-comment" do
            fill_in 'Your comment', with: 'New comment'
            click_on 'Add comment'
          end
          expect(page).to have_content('New comment')
        end
        Capybara.using_session('guest') do
          within "#answer-comments-#{answer.id}" do
            expect(page).to have_content('New comment')
          end
        end
      end
    end

end
