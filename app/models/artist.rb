class Artist < ActiveRecord::Base
  has_many :artist_aliases
  
  default_scope includes(:artist_aliases)
end
