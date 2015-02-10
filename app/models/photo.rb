class Photo < ActiveRecord::Base
  belongs_to :venue
  has_one :reaction
end
