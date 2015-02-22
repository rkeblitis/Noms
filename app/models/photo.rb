class Photo < ActiveRecord::Base
  belongs_to :venue
  has_many :reactions

  def self.find_unflagged
    self.where('(SELECT Count(*) FROM reactions WHERE reactions.photo_id = photos.id AND reactions.reaction = ?) < 3', "flag")
  end

  def self.find_no_reaction(user_id)
    # returns a photo, from a venue, that has no reaction from a particular user:
    # the count(*) selcts where the values is NOT there
    # reactions.where('user_id = ?', user_id.to_s).where('reaction.created_at > ?', 15.minutes.ago)
    self.where('(SELECT Count(*) FROM reactions WHERE reactions.photo_id = photos.id AND reactions.user_id = ? AND reactions.created_at > ?) = 0', user_id.to_s, 15.minutes.ago)
  end



end

#
# find_no_reaction:
# basically it's saying: Find all photos where a specific user gave a reaction where the photo's
# reaction (the reaction model contatins a photo_id attribute) is == to the
# photo_id of the Photo model, and where that reaction was created longer
# than 15 mins ago. The SELECT Count(*) says to return all objects where these these conditions equal a count of 0.
# So it's kind of selecting for a negitive results in a way, It's find the photos where these conditions are not true.
# Which provides the funtionality of never showing a user the same picture during a 15 min session.
#
# To futher expand and complete the idea, when a photo gets flagged 3 times I didn't want that photo showen to any user again even after the 15min was up
# so the find_unflagged method does something similar where it finds all photos where the reaction.photo_id == the id in the photos table (this just slects for pics that have a reaction) and where the reaction the user gave was "flag".
# The Count here says select photos that have been given the reaction of flagged < 3 times, leaving the photos that have been flagged 3 times behind.
#
# so I can call Photo.find_unflagged.find_no_reaction(user_id) to pull up photos that a user hasn't seen in the last 15mins and that haven't been flagged 3 times or more.
