class CreateVenues < ActiveRecord::Migration
  def change
    create_table:venues do |t|
      t.string :foursquare_venue_id
      t.string :name
      t.string :phone_number
      t.text :address
      t.text :category

      t.timestamps
    end
  end
end
