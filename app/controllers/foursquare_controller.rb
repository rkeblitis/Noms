class FoursquareController < ApplicationController

  def index
  @venue_response = HTTParty.get("https://api.foursquare.com/v2/venues/search?ll=47.624784,-122.356922&radius=500&categoryId=4d4b7105d754a06374d81259&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")
  venue_ids = []
  @venue_response.parsed_response["response"]["venues"].each do |venue|
    venue_ids << venue["id"]
  end
  individual_info(venue_ids)
  end

  def individual_info(venue_ids)
    id = venue_ids.sample
    @pic = []
    id_response = HTTParty.get("https://api.foursquare.com/v2/venues/#{id}/photos?&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")["response"]["photos"]["items"]
    id_response.each do |pic_info|
      prefix = pic_info["prefix"]
      suffix = pic_info["suffix"]
      photo_url = prefix + "400x400" + suffix
      @pic << photo_url
    end
    respond_to do |format|
       format.html {render html: @pic.sample }
       
    end

  end

end


# seperate my api so that noms can make a call and get one picture at a time
# only query a venue id when needed to help optimization


# @pics = []
# venue_ids.each do |id|
#   id_response = HTTParty.get("https://api.foursquare.com/v2/venues/#{id}/photos?&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")["response"]["photos"]["items"]
#   id_response.each do |pic_info|
#     prefix = pic_info["prefix"]
#     suffix = pic_info["suffix"]
#     photo_url = prefix + "400x400" + suffix
#     @pics << photo_url
#   end
# end
# render json: @pics
