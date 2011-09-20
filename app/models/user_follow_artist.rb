class UserFollowArtist < ActiveRecord::Base
  belongs_to :user
  belongs_to :follow_artists, :class_name => 'Artist', :foreign_key => 'artist_id'
end
