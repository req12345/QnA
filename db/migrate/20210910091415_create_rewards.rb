class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.belongs_to :question, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
