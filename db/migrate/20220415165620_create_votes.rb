class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :votable
      t.string :votable_type
      t.belongs_to :user

      t.timestamps
    end
  end
end
