class Reaction < ActiveRecord::Base
  validates :photo_id, :user_id, :reaction, {presence: true}
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
      if v >= 3
        # find venues within the user's location that match category of k
        result_venues = Venue.within(0.25, :origin => [lat, lon])
        result_venues.each do |venue|
          if venue.category == k
            @results << {name: venue.name, address: venue.address, phone_number: venue.phone_number, category: venue.category}
          end
        end
      end
    end
    @results
  end
end
