class UsersArtistItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :artist_item
end
