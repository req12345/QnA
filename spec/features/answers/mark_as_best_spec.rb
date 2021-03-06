require 'rails_helper'

feature 'User can marks answer best', %q{
  In order to mark question wich helped
  As an author of question
  I'd like to be able to mark answer
} do

  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given(:question_with_reward) { create(:question, :with_reward, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario 'Author can marks answer as best', js: true do
    sign_in(author)
    visit question_path(question)

    within '.answers' do
      expect(page).to have_link 'Mark as best'
      click_on 'Mark as best'
      question.reload
      expect(page).to have_content 'The best answer'
      expect(page).to have_content question.best_answer.body
    end
  end

  scenario 'Author of answer recieve reward', js: true do
    rewarded_answer = create(:answer, question: question_with_reward, author: not_author)
    sign_in(author)
    visit question_path(question_with_reward)

    click_on 'Mark as best'
    question_with_reward.reload

    expect(question_with_reward.reward.user_id).to eq not_author.id
  end

  scenario 'Not author can not marks answer as best', js: true do
    sign_in(not_author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Mark as best'
    end
  end

  scenario 'Guest can not marks answer as best', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Mark as best'
    end
  end
end
