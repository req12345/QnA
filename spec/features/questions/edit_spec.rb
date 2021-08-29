# require 'rails_helper'
#
# feature 'User can edit his question', %q{
#   In order to correct mistakes
#   As an author of question
#   I'd like to be able to edit my question
# } do
#
#   scenario 'Unauthenticated user can not edit answer' do
#     visit question_path(question)
#
#     within '.questions' do
#       expect(page).to_not have_link 'Edit'
#     end
#   end
# end
