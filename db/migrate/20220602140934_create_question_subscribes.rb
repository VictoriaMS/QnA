class CreateQuestionSubscribes < ActiveRecord::Migration[5.2]
  def change
    create_table :question_subscribes do |t|
      t.references :user
      t.references :question
    end
  end
end
