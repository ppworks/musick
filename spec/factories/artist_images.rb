# coding: utf-8
FactoryGirl.define do
  factory :artist_image_larc, :class => ArtistImage do
    artist {Factory.build :artist_larc}
    original 'http://userserve-ak.last.fm/serve/_/90003/LArcenCiel.jpg'
    large 'http://userserve-ak.last.fm/serve/126/90003.jpg'
    largesquare 'http://userserve-ak.last.fm/serve/126s/90003.jpg'
    medium 'http://userserve-ak.last.fm/serve/64/90003.jpg'
    small 'http://userserve-ak.last.fm/serve/34/90003.jpg'
    extralarge 'http://userserve-ak.last.fm/serve/252/90003.jpg'
    show_flg TRUE
    created_at '2011-09-20 06:38:05'
    updated_at '2011-09-20 06:38:05'
  end
end