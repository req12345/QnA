require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to explain or asks something else about question
  As an authenticated user
  I'd like to be able to add comments
} do
    given(:user) { create(:user) }
    given(:question) { create(:question, author: user) }

    it "User add comment to question", js: true do
      sign_in(user)
      visit question_path(question)
      within ".new-question-comment" do
        fill_in 'Your comment', with: 'New comment'
        click_on 'Add comment'
      end
      expect(page).to have_content('New comment')
    end

    it 'Guest can not add comment', js: true do
      visit question_path(question)
      expect(page).to_not have_button 'Add comment'
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
          within ".new-question-comment" do
            fill_in 'Your comment', with: 'New comment'
            click_on 'Add comment'
          end
          expect(page).to have_content('New comment')
        end
        Capybara.using_session('guest') do
          expect(page).to have_content('New comment')
        end
      end
    end

end
