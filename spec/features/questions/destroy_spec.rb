require 'rails_helper'

feature 'User can delete question', %q{
  In order to remove question
  As an question author
  I'd like to be able to delete question
} do

  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, author: user) }


  scenario 'Author delete his question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.title
    click_on 'Delete question'

    expect(page).to have_content 'Your question deleted'
    expect(page).to_not have_content question.title
  end

  scenario 'Not author can not delete question' do
    sign_in(not_author)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Unauthenticated user can not delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

end
