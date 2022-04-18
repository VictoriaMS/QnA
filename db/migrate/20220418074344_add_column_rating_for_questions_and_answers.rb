class AddColumnRatingForQuestionsAndAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :raiting, :integer, default: 0
    add_column :questions, :raiting, :integer, default: 0
  end
end
