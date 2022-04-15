class AddColumnsVotedUpAndVotedDownForAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :voted_up, :integer, default: 0
    add_column :answers, :voted_down, :integer, default: 0
  end
end
