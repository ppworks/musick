class Post
  include ActionView::Helpers
  def post_artist_track params_yml, message
    params = YAML.load params_yml
    artist_track = ::ArtistTrack.find_or_create(params[0], params[1], params[2], params[3])
    artist_item = artist_track.artist_item
    user_action = UserAction.where(:name => 'post', :target => 'artist_track').first

    self.posts_user_action = PostsUserAction.new(
      :user_action_id => user_action.id,
      :target_attributes => params_yml,
      :target_name => artist_item.title
    )
    self.posts_artist_track = PostsArtistTrack.new(
      :artist_track_id => artist_track.id
    )
    url = Rails.application.routes.url_helpers.artist_track_url artist_item.artist_id, artist_item.asin, artist_track.disc, artist_track.track, :host => APP_CONFIG[:domain]
    image = artist_item.medium_image_url
    description = artist_item.artist_tracks.map{|t|"#{t.track}. #{t.title}"}.join(" ")
    {
      :name => "#{artist_item.title} - #{artist_track.title} on Musick" , 
      :link => url,
      :picture => image,
      :description => truncate(description, :length => 100),
    }
  end
end