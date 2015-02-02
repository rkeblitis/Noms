class FoursquareController < ApplicationController

  def index
  @response = HTTParty.get("https://api.foursquare.com/v2/venues/search?ll=47.624784,-122.356922&radius=500&categoryId=4d4b7105d754a06374d81259&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")
  # render json: @response.parsed_response["response"]["venues"]
  ids = []
  @response.parsed_response["response"]["venues"].each do |venue|
    ids << venue["id"]
  end
  individual_info(ids)
  end

  def individual_info(ids)
    @pics = []
    ids.each do |id|
      id_response = HTTParty.get("https://api.foursquare.com/v2/venues/#{id}/photos?&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")["response"]["photos"]["items"]
      id_response.each do |pic_info|
        prefix = pic_info["prefix"]
        suffix = pic_info["suffix"]
        photo_url = prefix + "400x400" + suffix
        @pics << photo_url
      end
    end
    render json: @pics
  end

end
