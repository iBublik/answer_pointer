class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: true
      t.references :user, index: true, foreign_key: true
      t.index [:votable_id, :votable_type, :user_id], unique: true
      t.integer :value, default: 0, null: false

      t.timestamps null: false
    end
  end
end
