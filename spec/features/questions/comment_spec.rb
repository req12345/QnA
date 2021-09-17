require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to explain or asks something elsea bout question
  As an authenticated user
  I'd like to be able to add comments
} do
    given(:user) { create(:user) }
    given(:question) { create(:question, author: user) }

    it "User add comment to question" do
      visit question_path(question)
      within "#question-#{question.id}" do
        fill_in 'Your comment', with: 'New comment'
        click_on 'Add'
        expect(page).to have_content('New comment')
      end
    end


end
