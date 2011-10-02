require "benchmark"
require "pp"
namespace :lastfm do
  namespace :artist_image do
    desc 'Fetch artist image from last.fm.'
    task :fetch => :environment do
      
      puts Benchmark::CAPTION
      puts Benchmark.measure {
        puts "[START] lastfm:artist_image:fetch"
        Artist.all.each do |artist|
          artist_names = [artist.name] + artist.artist_aliases.map{|a|a.name}
          next if artist_names.nil?
          artist_names.each do |artist_name|
            begin
              res = LastfmWrapper::Base.api.artist.get_images :artist => artist_name, :autocorrect => 1, :limit => 25
            rescue
              next
            end
            next if res.nil?
            url = nil
            res.each do |r|
              next if r['sizes'].nil? || r['sizes']['size'].nil?
              r['sizes']['size'].each do |size|
                if size['name'] == 'largesquare'
                  url = size['content']
                  begin
                    artist.artist_images << ArtistImage.new(:url => url)
                    artist.save!
                  rescue => e
                    pp e.message
                  end
                end
              end
              pp url if url.present?
            end
          end
        end
        puts "[END]"
      }
    end
  end
end