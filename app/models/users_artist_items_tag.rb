class UsersArtistItemsTag < ActiveRecord::Base
  belongs_to :user
  belongs_to :artist_item
  belongs_to :tag
end
