class Venue < ActiveRecord::Base
  has_many :photos

  def self.get_picture(venues,user_id)
    venue = venues.sample
    photos = venue.photos
    while photos.empty?
      venue = venues.sample
      photos = venue.photos
    end
    photo = photos.find_no_reaction(user_id).sample
  end

end
