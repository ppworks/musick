class Post
  include ActionView::Helpers
  def post_artist params_yml, message
    params = YAML.load params_yml
    artist = ::Artist.where(:id => params[0]).first
    user_action = UserAction.where(:name => 'post', :target => 'artist').first

    self.posts_user_action = PostsUserAction.new(
      :user_action_id => user_action.id,
      :target_attributes => params_yml,
      :target_name => artist.name
    )
    url = Rails.application.routes.url_helpers.artist_url artist.id, :host => APP_CONFIG[:domain]
    image = artist.artist_lastfm.thumbnail_image
    description = artist.artist_lastfm.summary
    {
      :name => "#{artist.name} on Musick" , 
      :link => url,
      :picture => image,
      :description => truncate(description, :length => 100),
    }
  end
end