require 'sphinx_helper'

feature 'User can search', %q{
  In order to find important information
  As an any role user
  I'd like to be able to searching records by keywords
}, js: true, sphinx: true do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'User search within All data tha is not present', sphinx: true do
    visit root_path

    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :body, with: 'not existing data'
        click_on 'Search'
      end

      expect(page). to have_content 'No results'
    end
  end

  # scenario 'User search within All data tha is present', sphinx: true do
  #   visit root_path
  #
  #   ThinkingSphinx::Test.run do
  #     within '.search' do
  #       select 'All', from: :type
  #       fill_in :body, with: question.title
  #       click_on 'Search'
  #     end
  #
  #     expect(page). to have_content question.title
  #   end
  # end
  #
  # scenario 'User search within All data tha is present', sphinx: true do
  #   visit root_path
  #
  #   ThinkingSphinx::Test.run do
  #     within '.search' do
  #       select 'Question', from: :type
  #       fill_in :body, with: question.title
  #       click_on 'Search'
  #     end
  #
  #     expect(page). to have_content question.title
  #   end
  # end
end
