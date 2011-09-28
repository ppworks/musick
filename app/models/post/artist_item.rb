class Post
  include ActionView::Helpers
  def post_artist_item params_yml, message
    params = YAML.load params_yml
    artist_item = ::ArtistItem.find_or_create(params[0], params[1])
    user_action = UserAction.where(:name => 'post', :target => 'artist_item').first

    self.posts_user_action = PostsUserAction.new(
      :user_action_id => user_action.id,
      :target_attributes => params_yml,
      :target_name => artist_item.title
    )
    url = Rails.application.routes.url_helpers.artist_item_url artist_item.artist_id, artist_item.asin, :host => APP_CONFIG[:domain]
    image = artist_item.medium_image_url
    description = artist_item.artist_tracks.map{|t|"#{t.track}. #{t.title}"}.join(" ")
    {
      :name => "#{artist_item.title} on Musick" , 
      :link => url,
      :picture => image,
      :description => truncate(description, :length => 100),
    }
  end
end