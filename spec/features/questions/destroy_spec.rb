require 'rails_helper'

feature 'User can delete question', %q{
  In order to remove question
  As an question author
  I'd like to be able to delete question
} do

  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question) }
  given(:question_with_file) { create(:question, :with_file, author: user) }

  describe 'Author' do
    before do
      sign_in(question_with_file.author)
      visit question_path(question_with_file)
    end

    scenario 'can deletes attachments', js: true do
      within '.question' do
        expect(page).to have_link file_name(question_with_file)
        click_on 'Delete file'

        expect(page).to_not have_link file_name(question_with_file)
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario 'deletes his question' do
      expect(page).to have_content question_with_file.title
      click_on 'Delete question'

      expect(page).to have_content 'Your question deleted'
      expect(page).to_not have_content question_with_file.title
    end
  end

  describe 'Not author' do
    before do
      sign_in(not_author)
      visit question_path(question_with_file)
    end

    scenario 'can not deletes attachments', js: true do
      within '.question' do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario 'can not deletes question' do
      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user can not deletes question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  def file_name(item)
    item.files[0].filename.to_s
  end
end
