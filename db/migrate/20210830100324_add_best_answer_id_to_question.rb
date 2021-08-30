class AddBestAnswerIdToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :best_answer, null: true
  end
end
