class AddToColumnForQuestionsAndAnswers < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :user
    add_reference :answers, :user 
  end
end
