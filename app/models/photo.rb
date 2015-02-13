class Photo < ActiveRecord::Base
  belongs_to :venue
  has_one :reaction

  def self.find_no_reaction(user_id)
    self.where('(SELECT Count(*) FROM reactions WHERE reactions.photo_id = photos.id AND reactions.user_id = ?) = 0', user_id.to_s)
  end

end
