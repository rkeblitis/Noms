class FoursquareController < ApplicationController

  def index
  @venues = []
  # return all the venues near me:
  @venue_response = HTTParty.get("https://api.foursquare.com/v2/venues/search?ll=47.624784,-122.356922&radius=500&categoryId=4d4b7105d754a06374d81259&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")
  @venue_response.parsed_response["response"]["venues"].each do |venue_info|
    if Venue.exists?(foursquare_venue_id: venue_info["id"])
      @venues << Venue.find_by(foursquare_venue_id: venue_info["id"])
      # ***** I need to add && Venue.where(updated_at: = < 24 hours ) or something like that *****
    else
      venue = Venue.create(
      foursquare_venue_id:  venue_info["id"],
      name:                 venue_info["name"],
      phone_number:         venue_info["contact"]["formattedPhone"],
      address:              venue_info["location"]["formattedAddress"].join(" "),
      category:             venue_info["categories"][0]["name"]
      )
      @venues << venue
    end
  end
    individual_info
    # query photo here
    @venue_ids = @venues.map do |venue|
      venue.id
    end
    Photo.where(venue_id: @venue_ids)
    # will return all photo obj where this is true, sample from here
    end
  end


  def individual_info
    @venues.each do |venue|
      photo_response = HTTParty.get("https://api.foursquare.com/v2/venues/#{venue.foursquare_venue_id}/photos?&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")["response"]["photos"]["items"]
      photo_response.each do |pic_info|
        prefix = pic_info["prefix"]
        suffix = pic_info["suffix"]
        photo_url = prefix + "400x400" + suffix
        Photo.create(url: photo_url, venue_id: venue.id)

      end
    end

  end

end
