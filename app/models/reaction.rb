class Reaction < ActiveRecord::Base
  belongs_to :photo

  def self.check_if_done(current_time, time_range, user_id)
    @count = Hash.new
    @results = []
    nom_reactions = Reaction.where(reaction: "nom", created_at: current_time.. time_range, user_id: user_id)
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
    @results
  end
end
