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

    counter = 0
    questions.each do |question|
      counter += 1 if question.valid?
     expect(page).to have_content question.title
    end
    expect(counter).to eq questions.count
  end
end
