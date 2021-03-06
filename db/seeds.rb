unless Rails.env.test?
  # artists
  if Artist.all.count == 0
    artists = File.read("#{Rails.root}/db/seeds/artists.yml")
    Artist.delete_all
    artist_list = YAML.load(artists).symbolize_keys
    artist_list[:artists].each do |a|
      Artist.create_by_lastfm(a)
    end
  end
  
  # artist_aliases
  if ArtistAlias.all.count == 0
    artist_aliases = File.read("#{Rails.root}/db/seeds/artist_aliases.yml")
    ArtistAlias.delete_all
    artist_aliases_list = YAML.load(artist_aliases).symbolize_keys
    artist_aliases_list[:artist_aliases].each do |key, val|
      artist = Artist.find_by_name key
      if artist.present?
        val = val.split(/\t/)
        val.each do |v|
          ArtistAlias.create(:artist_id => artist.id, :name => v)
        end
      end
    end
  end
end

if UserAction.all.count == 0
  user_actions = File.read("#{Rails.root}/db/seeds/user_actions.yml")
  user_actions_list = YAML.load(user_actions).symbolize_keys
  user_actions_list[:user_actions].each do |user_action|
    UserAction.create(user_action)
  end
end

if Tag.all.count == 0
  tags = File.read("#{Rails.root}/db/seeds/tags.yml")
  tags_list = YAML.load(tags).symbolize_keys
  tags_list[:tags].each do |tag|
    Tag.create(tag)
  end
end

# providers
if Provider.all.count == 0
  Provider.create :id =>1, :name => 'facebook'
  Provider.create :id =>2, :name => 'twitter'
  Provider.create :id =>3, :name => 'mixi'
end