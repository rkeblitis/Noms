require 'rails_helper'

RSpec.describe Venue, :type => :model do

  describe "#get_picture" do
    # let block for fixture, factory girl gem that creates test obj)
    xit "returns a photo" do
      expect (Venue.get_picture()).to_not be_empty
    end
  end

end
