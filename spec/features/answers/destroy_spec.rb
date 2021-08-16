require 'rails_helper'

feature 'User can delete answer', %q{
  In order to remove answer of a question
  As an answer author
  I'd like to be able to delete answer
} do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, author: user) }

  scenario 'Author delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Not author can not delete question' do
    sign_in(not_author)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Unauthenticated user can not delete question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
