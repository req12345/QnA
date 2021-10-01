require 'rails_helper'

feature 'User can subscribe on the question', %q{
    In order to recieve notification about new answers
    As an authenticated user
    I would like to able to subscribe on the question
} do

  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:subscription) { create(:subscription, question: question, user: author) }

  describe 'Authenticated user' do
    context 'as auhtor' do
      scenario 'can unsubscribe', js: true do
        sign_in(author)
        visit question_path(question)

        within('.subscription') do
        expect(page).to_not have_content 'Subscribe'
        expect(page).to have_content 'Unsubscribe'

        click_on 'Unsubscribe'

        expect(page).to have_content 'Subscribe'
        expect(page).to_not have_content 'Unsubscribe'
        end
      end
    end

    context "Another user", js: true do
      given(:user) { create(:user) }

      scenario "can subscribe" do
        sign_in(user)
        visit question_path(question)

        within('.subscription') do
          expect(page).to_not have_content 'Unsubscribe'
          expect(page).to have_content 'Subscribe'

          click_link 'Subscribe'

          expect(page).to have_content 'Unsubscribe'
          expect(page).to_not have_content 'Subscribe'
        end
      end
    end
  end

  describe "Non-authenticated user", js: true do
    scenario "can't subscribe or unsubscribe" do
      visit question_path(question)
      expect(page).to_not have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end
end
