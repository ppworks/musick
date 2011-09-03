# coding: utf-8
FactoryGirl.define do
  factory :artist_alias_larc, :class => ArtistAlias do
    name "ラルク・アン・シエル"
    artist {Factory.build :artist_larc}
  end
end