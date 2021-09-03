require 'rails_helper'

feature 'User can delete answer', %q{
  In order to remove answer of a question
  As an answer author
  I'd like to be able to delete answer
} do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) {create(:answer, question: question, author: user) }
  given(:answer_with_file) { create(:answer, :with_file, question: question, author: user) }

  describe 'Author' do
    before do
      sign_in(answer_with_file.author)
      visit question_path(answer_with_file.question)
    end

    scenario 'can delete attachments', js: true do
      within '.answers' do
        expect(page).to have_link file_name(answer_with_file)
        click_on 'Delete file'

        expect(page).to_not have_link file_name(answer_with_file)
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario 'delete his question', js: true do
      expect(page).to have_content answer_with_file.body
      click_on 'Delete answer'
      expect(page).to have_content 'Your answer deleted'
      expect(page).to_not have_content(answer_with_file.body)
    end
  end

  describe 'Not author' do
    before do
      sign_in(not_author)
      visit question_path(answer_with_file.question)
    end

    scenario 'Not author can not delete attachments', js: true do
      within '.answers' do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario 'Not author can not delete question', js: true do
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user can not delete question' do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Delete answer'
  end

  def file_name(item)
    item.files[0].filename.to_s
  end
end
