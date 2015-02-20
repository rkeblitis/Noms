class Venue < ActiveRecord::Base
  has_many :photos


  acts_as_mappable :default_units => :miles,
  :default_formula => :sphere,
  :distance_field_name => :distance,
  :lat_column_name => :lat,
  :lng_column_name => :lon

  def self.get_picture(venues,user_id)
    venue_ids = venues.map do |venue|
      venue.id
    end
    photos = Photo.where(venue_id: venue_ids)
    photos.find_no_reaction(user_id).sample
  end

  def query_pictures
    photo_response = HTTParty.get("https://api.foursquare.com/v2/venues/#{self.foursquare_venue_id}/photos?&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")["response"]["photos"]["items"]
    photo_response.each do |pic_info|
      prefix = pic_info["prefix"]
      suffix = pic_info["suffix"]
      photo_url = prefix + "600x600" + suffix
      unless Photo.exists?(url: photo_url)
        Photo.create(url: photo_url, venue_id: self.id)
      end
    end
  end

end

# add index for venue_id on photos and user_id
