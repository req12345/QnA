require 'rails_helper'

feature 'User view the list of questions', %q{
  In order to find a soluition of a problem
  As an user
  I'd like to be able to view the list of questions
  To find the question i'm interested in
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, author: user) }

  scenario 'User can views the list of questions' do
    visit questions_path

    questions.each do |question|
     expect(page).to have_content(question.title, count: questions.size)
    end
  end
end
