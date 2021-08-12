class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :question, foreign_key: true, null: false

      t.timestamps
    end
  end
end
