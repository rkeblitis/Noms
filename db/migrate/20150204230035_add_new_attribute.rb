class AddNewAttribute < ActiveRecord::Migration
  def change
    add_column :venues, :venue_pic, :string
  end
end
