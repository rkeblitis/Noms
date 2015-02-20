class AddLatLonToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :lat, :integer
    add_column :venues, :lon, :integer
  end
end
