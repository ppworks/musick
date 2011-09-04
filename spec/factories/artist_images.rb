# coding: utf-8
FactoryGirl.define do
  factory :artist_image_larc, :class => ArtistImage do
    url "ラルク・アン・シエル"
    artist {Factory.build :artist_larc}
  end
end