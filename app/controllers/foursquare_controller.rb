require 'time'
class FoursquareController < ApplicationController
  before_action :get_venues
  before_action :set_session
  before_action :set_time

  def done
    @count = Hash.new
    @results = []
    current_time = session[:current_time]
    # 900 sec == 15 mins
    time_range = current_time + (900)
    nom_reactions = Reaction.where(reaction: "nom", created_at: current_time.. time_range, user_id: session[:user_id])
    # Reaction.where('(SELECT Count(*) FROM reactions WHERE reactions.reaction = "nom" AND reactions.created_by = ?) = *', )
    # and created_by is < 15 mins old
    nom_reactions.each do |reaction|
      if @count.key?(reaction.photo.venue.category)
          @count[reaction.photo.venue.category] += 1
      else
        @count[reaction.photo.venue.category] = 1
      end
    end
    @count.each do |k ,v|
      if v == 3
        result_venues = Venue.where(category: k)
        result_venues.each do |venue|
          result = venue.name, venue.address, venue.phone_number, venue.category
          @results << result
      end
      end
    end
    render json: @results
  end

  def get_picture
    # returns a photo, from a venue, that has no reaction from a particular user:
      photo = Venue.get_picture(@venues, session[:user_id])
      render json: photo
    # Photo.where('(SELECT Count(*) FROM reactions WHERE reactions.photo_id = photos.id AND reactions.user_id = ?) = 0', session[:user_id])
  end

  def query_pictures
      # for each venue.id make api request for photos
      @venues.each do |venue|
        photo_response = HTTParty.get("https://api.foursquare.com/v2/venues/#{venue.foursquare_venue_id}/photos?&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")["response"]["photos"]["items"]
        # for each photo response parse out photo url
        photo_response.each do |pic_info|
          prefix = pic_info["prefix"]
          suffix = pic_info["suffix"]
          photo_url = prefix + "600x600" + suffix
          # create new Photo active record objects with current venue.id
          if Photo.exists?(url: photo_url)
            photo_url = "http://assets.atlasobscura.com/media/BAhbCVsHOgZmSSJGdXBsb2Fkcy9wbGFjZV9pbWFnZXMvYzI3OGVkNjRiOTVhYzNlNjBhZTkxOTdhNzZlZDI2Y2U0MTRhNzQzOS5qcGcGOgZFVFsIOgZwOgp0aHVtYkkiCjYwMHg+BjsGVFsHOwc6CnN0cmlwWwk7BzoMY29udmVydEkiEC1xdWFsaXR5IDkxBjsGVDA/image.jpg"
          else
            Photo.create(url: photo_url, venue_id: venue.id)
          end
        end
      end

  end
# -------------------------------------------------------------------------------------------------------------------
  private

  def set_time
    if session[:current_time] == nil
      session[:current_time] = Time.now
    else
      if
      session[:current_time] < 2.minutes.ago
        session[:current_time] = Time.now
      else
        session[:current_time] = Time.parse(session[:current_time])
      end
    end
  end

  def set_session
    if session[:user_id] == nil
      current_user_id = SecureRandom.base64
      session[:user_id] = current_user_id
    else
      session[:user_id] = session[:user_id]

    end

  end

  def get_venues
    @venues = []
    # return all the venues near me:
    @venue_response = HTTParty.get("https://api.foursquare.com/v2/venues/search?ll=#{params[:lat]},#{params[:lon]}&radius=500&categoryId=4d4b7105d754a06374d81259&client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150126")
      @venue_response.parsed_response["response"]["venues"].each do |venue_info|
      if Venue.exists?(foursquare_venue_id: venue_info["id"])
        @venues << Venue.find_by(foursquare_venue_id: venue_info["id"])
        # ***** I need to add && Venue.where(updated_at: = < 24 hours ) or something like that *****
      else
        # create new Venue active record objects
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

end
