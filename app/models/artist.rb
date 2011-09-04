class Artist < ActiveRecord::Base
  has_many :artist_aliases
  has_many :artist_images
  default_scope includes(:artist_aliases)
  default_scope includes(:artist_images)
  scope :search_name, lambda{|keyword| 
    joins(:artist_aliases)
    .where("artists.name LIKE :keyword OR artist_aliases.name LIKE :keyword",
        :keyword => "%#{keyword}%")
  }
end
