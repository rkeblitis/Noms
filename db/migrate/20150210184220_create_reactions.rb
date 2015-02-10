class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.integer :user_id
      t.string :reaction
      t.integer :photo_id

      t.timestamps
    end
  end
end
