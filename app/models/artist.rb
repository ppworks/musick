class Artist < ActiveRecord::Base
  has_many :artist_aliases
  has_many :artist_images
  default_scope includes(:artist_aliases)
  default_scope includes(:artist_images)
end
