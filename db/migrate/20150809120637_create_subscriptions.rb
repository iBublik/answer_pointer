class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true
      t.index [:user_id, :question_id], unique: true

      t.timestamps null: false
    end
  end
end
