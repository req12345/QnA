require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:question_with_answer) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Edit answers link' do
    given!(:answer_with_link) { create(:answer, :with_link, question: question_with_answer, author: user) }

    scenario 'by author', js: true do
      sign_in(user)
      visit question_path(answer_with_link.question)
      click_on 'Edit'
      within ".answers" do
        expect(page).to have_link 'MyString', href: 'http://valid.com'

        fill_in 'Link name', with: 'New link name'
        fill_in 'Url', with: 'http://newurl.com'
        click_on 'Save'
      end
      expect(page).to_not have_link 'MyString', href: 'http://valid.com'
      expect(page).to have_link 'New link name', href: 'http://newurl.com'
    end

    scenario 'by user', js: true do
      sign_in(not_author)
      visit question_path(answer_with_link.question)
      within ".answers" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario "Not author tries to edit other user's answer" do
    sign_in(not_author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    context 'as author' do
      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit'
      end

      scenario 'edits his answer with errors', js: true do
        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'
          expect(page).to have_content(answer.body)
          expect(page).to have_selector 'textarea'
        end

        within '.answer-errors' do
          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'edits his answer', js: true do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
        end
      end

      scenario ' edits his answer and attaches file', js: true do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to have_link answer.files.first.filename.to_s
          expect(page).to have_link answer.files.second.filename.to_s
        end
      end
    end
  end

  def link_id(item)
    item.links.first.id
  end
end
