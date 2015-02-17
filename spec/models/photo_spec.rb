require 'rails_helper'

RSpec.describe Photo, :type => :model do
  describe "#find_no_reaction" do
    before do
      photo1 = Photo.create(url: "placekitten.com/g/200/300", venue_id: 0)
      photo2 = Photo.create(url: "https://irs3.4sqi.net/img/general/400x400/460_nqxI4iyW2CZFWk88mfYOTZYN5DlnhcAka_ItbE2qpoE.jpg", venue_id: 0)
      photo3 = Photo.create(url: "http://static.guim.co.uk/sys-images/Education/Pix/pictures/2013/1/17/1358446759827/A-three-toed-tree-sloth-h-008.jpg", venue_id: 0)

      user1_id = "1"
      user2_id = "2"
      Reaction.create(user_id: user1_id, photo_id: photo1.id, reaction: "flag")


    end
    it "does not return photos with a reaction" do
      puts Photo.all
      puts Reaction.all
      expect(Photo.find_no_reaction(1).count).to eq 1
      #expect(Photo.find_no_reaction(2).count).to eq 1
      expect(Photo.find_no_reaction(1).all? { |photo| photo.class == Photo }).to eq true
    end

  end
end
