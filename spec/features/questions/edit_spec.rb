require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Edit questions link' do
    given!(:question_with_link) { create(:question, :with_link, author: user) }

    scenario 'by author', js: true do
      sign_in(user)
      visit question_path(question_with_link)

      within '.question' do
        click_on 'Edit'
        expect(page).to have_link 'MyString', href: 'http://valid.com'

        fill_in 'Link name', with: 'New link name'
        fill_in 'Url', with: 'http://newurl.com'
        click_on 'Save'
        expect(page).to_not have_link 'MyString', href: 'http://valid.com'
        expect(page).to have_link 'New link name', href: 'http://newurl.com'
      end
    end

    scenario 'by user', js: true do
      sign_in(not_author)
      visit question_path(question_with_link)
      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user can not edit question', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario "Not author tries to edit other user's question", js: true do
    sign_in(not_author)
    visit question_path(question)

    within '.question' do
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

      scenario 'edits his question with errors', js: true do
        within '.question' do
          fill_in 'Your question', with: ''
          click_on 'Save'
          expect(page).to have_content(question.title)
          expect(page).to have_content(question.body)
          expect(page).to have_selector 'textarea'
        end

        within '.question-errors' do
          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'edits his question', js: true do
        within '.question' do
          fill_in 'Title', with: 'edited title'
          fill_in 'Your question', with: 'edited body'
          click_on 'Save'

          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited body'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario ' edits his question and attaches file', js: true do
        within '.question' do
          fill_in 'Your question', with: 'edited question'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited question'
          expect(page).to have_link question.files.first.filename.to_s
          expect(page).to have_link question.files.second.filename.to_s
        end
      end
    end
  end
end
