class AddLatLonToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :lat, :float
    add_column :venues, :lon, :float
  end
end
