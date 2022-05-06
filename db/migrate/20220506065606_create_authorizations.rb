class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.references :user
      t.string :provider
      t.string :uid

      t.index [:provider, :uid]
      t.timestamps
    end
  end
end
