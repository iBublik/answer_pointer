class AddRatingToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :rating, :integer, default: 0
  end
end
