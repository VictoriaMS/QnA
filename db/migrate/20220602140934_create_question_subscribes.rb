class CreateQuestionSubscribes < ActiveRecord::Migration[5.2]
  def change
    create_table :question_subscribes do |t|
      t.references :user
      t.references :question
      t.boolean :subscribe, default: false
    end
  end
end
