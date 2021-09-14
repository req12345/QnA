require 'rails_helper'

feature 'User can vote for a answer', %q{
  In order to show that answer is usefull
  As an authenticated user
  I'd like to be able to vote
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  describe 'User is not an author of question', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'votes up for answer', js: true do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Rating: 0'
        click_on '+'

        within ".rating" do
          expect(page).to have_content 'Rating: 1'
        end
      end
    end

    scenario 'tries to vote up for answer twice' do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Rating: 0'
        click_on '+'
        click_on '+'

        within ".rating" do
          expect(page).to have_content 'Rating: 1'
        end
      end
    end

    scenario 'cancels his vote' do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Rating: 0'
        click_on '+'
        click_on 'Cancel voting'

        within '.rating' do
          expect(page).to have_content 'Rating: 0'
        end
      end
    end

    scenario 'votes down for answer' do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Rating: 0'
        click_on '-'

        within '.rating' do
          expect(page).to have_content 'Rating: -1'
        end
      end
    end

    scenario 'tries to vote down for answer twice' do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Rating: 0'
        click_on '-'
        click_on '-'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'can re-votes' do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Rating: 0'
        click_on "+"
        click_on 'Cancel voting'
        click_on '-'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  describe 'User is author of answer tries to', js: true do
    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'vote up for his answer' do
      expect(page).to_not have_selector '.vote-actions'
    end

    scenario 'vote down for his answer' do
      expect(page).to_not have_selector '.vote-actions'
    end

    scenario 'cancel vote' do
      expect(page).to_not have_selector '.vote-actions'
    end
  end

  describe 'Unauthorized user tries to' do

    background { visit question_path(question) }

    scenario 'vote up for answer' do
      expect(page).to_not have_selector '.vote-actions'
    end

    scenario 'vote down for answer' do
      expect(page).to_not have_selector '.vote-actions'
    end

    scenario 'cancel vote' do
      expect(page).to_not have_selector '.vote-actions'
    end
  end
end
