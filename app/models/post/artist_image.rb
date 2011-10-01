class Post
  include ActionView::Helpers
  def post_artist_image params_yml, message
    params = YAML.load params_yml
    artist_image = ::ArtistImage.includes(:artist).where(:id => params[0]).first
    artist = artist_image.artist
    user_action = UserAction.where(:name => 'post', :target => 'artist_image').first

    self.posts_user_action = PostsUserAction.new(
      :user_action_id => user_action.id,
      :target_attributes => params_yml,
      :target_name => artist.name
    )
    self.posts_artist_image = PostsArtistImage.new(
      :artist_image_id => artist_image.id
    )
    url = Rails.application.routes.url_helpers.artist_image_url artist.id, artist_image.id , :host => APP_CONFIG[:domain]
    
    image = artist_image.largesquare
    description = artist.artist_lastfm.summary
    {
      :name => "#{artist.name} on Musick" , 
      :link => url,
      :picture => image,
      :description => truncate(description, :length => 100),
    }
  end
end