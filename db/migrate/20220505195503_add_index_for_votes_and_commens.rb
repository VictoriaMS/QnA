class AddIndexForVotesAndCommens < ActiveRecord::Migration[5.2]
  def change
    add_index(:votes, [:votable_id, :votable_type])
    add_index(:comments, [:commentable_id, :commentable_type])
  end
end
