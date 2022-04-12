class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.string :file
      t.references :attachable
      t.string :attachable_type
      t.index [:attachable_id, :attachable_type]

      t.timestamps
    end
  end
end
