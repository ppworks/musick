require 'image_size'
require 'open-uri'
class ArtistImage < ActiveRecord::Base
  belongs_to :artist
  
  def get_image_size size = 'original'
    image = nil
    open(self.send(size), 'rb') do |fh|
      image = ::ImageSize.new(fh.read)
    end
    if image.present?
      w = image.w
      h = image.h
      if w < h
        if h > 512
          w = ((w.to_f / h.to_f) * 512).to_i
          h = 512
        end
      else
        if w > 512
          h = ((h.to_f / w.to_f) * 512).to_i
          w = 512
        end
      end
      {
        :width => w,
        :height => h,
      }
    else
      {
        :width => 0,
        :height => 0
      }
    end
  end
end
