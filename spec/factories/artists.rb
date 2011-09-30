# coding: utf-8
FactoryGirl.define do
  factory :artist_larc, :class => Artist do
    id 1
    name "L'Arc~en~Ciel"
    show_flg TRUE
    created_at Time.now
    updated_at Time.now
    image_searched_at Time.now
  end
end