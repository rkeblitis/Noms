class Reaction < ActiveRecord::Base
  belongs_to :photo
  # belongs_to:user

  def self.check_if_done(user_id, lat, lon)
    @count = Hash.new
    @results = []
    nom_reactions = self.where(reaction: "nom", created_at: 5.minutes.ago..Time.now, user_id: user_id)
    nom_reactions.each do |reaction|
      if @count.key?(reaction.photo.venue.category)
        @count[reaction.photo.venue.category] += 1
      else
        @count[reaction.photo.venue.category] = 1
      end
    end
    @count.each do |k ,v|
      if v == 3
        # find venues within the user's location that match category of k
        result_venues = Venue.within(0.25, :origin => [lat, lon])
        result_venues.each do |venue|
          if venue.category == k
            @results << [venue.name, venue.address, venue.phone_number, venue.category]
          end
        end
      end
    end
    @results
  end
end
