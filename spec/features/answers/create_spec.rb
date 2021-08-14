require 'rails_helper'

feature 'User can create answer', %q{
  In order to help a man
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Authenticated user answers the question' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'text text text'
  end


end
