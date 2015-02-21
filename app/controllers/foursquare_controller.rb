class FoursquareController < ApplicationController
  before_action :get_venues


  def get_picture
    photo = Venue.get_picture(@venues, session[:user_id], params[:number].to_i)
    render json: photo
  end

  def info
    photo = Photo.find(params["photo_id"])
    photo_info = {name: photo.venue.name, category: photo.venue.category, address: photo.venue.address, phone_number: photo.venue.phone_number}
    render json: photo_info
  end

  end

  private

  def get_venues
    @venues = []
    venue_response = HTTParty.get("https://api.foursquare.com/v2/venues/search?ll=#{params[:lat]},#{params[:lon]}&radius=500&categoryId=4d4b7105d754a06374d81259&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")
    venue_response.parsed_response["response"]["venues"].each do |venue_info|
    if venue = Venue.find_by(foursquare_venue_id: venue_info["id"])
      @venues << venue
      # ***** I need to add && Venue.where(updated_at: = < 24 hours ) or something like that *****
    else
      venue = Venue.create(
      foursquare_venue_id:  venue_info["id"],
      name:                 venue_info["name"],
      phone_number:         venue_info["contact"]["formattedPhone"],
      address:              venue_info["location"]["formattedAddress"].join(" "),
      category:             venue_info["categories"][0]["name"],
      lat:                  params[:lat].to_f,
      lon:                  params[:lon].to_f
      )
      # add Venues objects to []
      @venues << venue
      venue.query_pictures
    end
  end


end
