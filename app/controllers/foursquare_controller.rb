require 'time'
class FoursquareController < ApplicationController
  before_action :get_venues


  def get_picture
    photo = Venue.get_picture(@venues, session[:user_id])
    while photo == nil
      photo = Venue.get_picture(@venues, session[:user_id])
      # {url: "http://img.4plebs.org/boards/tg/image/1401/25/1401256143635.jpg"}
    end
    render json: photo
  end

  # def info
  #
  # end

  end
# -------------------------------------------------------------------------------------------------------------------
  private

  def get_venues
    @venues = []
    @venue_response = HTTParty.get("https://api.foursquare.com/v2/venues/search?ll=#{params[:lat]},#{params[:lon]}&radius=500&categoryId=4d4b7105d754a06374d81259&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")
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
        # add Venues objects to []
        @venues << venue
        query_pictures
      end
    end
  end

  def query_pictures
    @venues.each do |venue|
      photo_response = HTTParty.get("https://api.foursquare.com/v2/venues/#{venue.foursquare_venue_id}/photos?&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")["response"]["photos"]["items"]
      photo_response.each do |pic_info|
        prefix = pic_info["prefix"]
        suffix = pic_info["suffix"]
        photo_url = prefix + "600x600" + suffix
        if Photo.exists?(url: photo_url)
          photo_url = "http://assets.atlasobscura.com/media/BAhbCVsHOgZmSSJGdXBsb2Fkcy9wbGFjZV9pbWFnZXMvYzI3OGVkNjRiOTVhYzNlNjBhZTkxOTdhNzZlZDI2Y2U0MTRhNzQzOS5qcGcGOgZFVFsIOgZwOgp0aHVtYkkiCjYwMHg+BjsGVFsHOwc6CnN0cmlwWwk7BzoMY29udmVydEkiEC1xdWFsaXR5IDkxBjsGVDA/image.jpg"
        else
          Photo.create(url: photo_url, venue_id: venue.id)
        end
      end
    end

end
