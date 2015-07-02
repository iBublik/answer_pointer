class AddRatingToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :rating, :integer, default: 0
  end
end
