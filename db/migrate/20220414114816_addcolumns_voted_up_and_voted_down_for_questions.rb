class AddcolumnsVotedUpAndVotedDownForQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :voted_up, :integer, default: 0
    add_column :questions, :voted_down, :integer, default: 0
  end
end
