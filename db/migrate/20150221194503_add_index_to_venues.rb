class AddIndexToVenues < ActiveRecord::Migration
  def change
    add_index :photos, :venue_id
    add_index :reactions, :photo_id
    add_index :reactions, :user_id
    add_index :reactions, :created_at

  end
end
