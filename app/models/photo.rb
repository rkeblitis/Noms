class Photo < ActiveRecord::Base
  belongs_to :venue
  has_many :reactions

  def self.find_no_reaction(user_id)
    # returns a photo, from a venue, that has no reaction from a particular user:
    # the count(*) selcts where the values is NOT there
    # reactions.where('user_id = ?', user_id.to_s).where('reaction.created_at > ?', 15.minutes.ago)
    self.where('(SELECT Count(*) FROM reactions WHERE reactions.photo_id = photos.id AND reactions.user_id = ? AND reactions.created_at > ?) = 0', user_id.to_s, 15.minutes.ago)
  end

  def self.find_unflagged
    self.where('(SELECT Count(*) FROM reactions WHERE reactions.photo_id = photos.id AND reactions.reaction = ?) < 3', "flag")
  end

end
