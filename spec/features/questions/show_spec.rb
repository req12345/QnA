require 'rails_helper'

feature 'User can look at question with answers', %q{
  In order to find a soluition of a problem
  As an user
  I'd like to be able to view the question i'm interested in
  I'd like to be able to view the question answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user)}

  background { visit question_path(question) }

  scenario 'User can view question attribute' do
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
  end

  scenario 'User can view question answers'  do
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
