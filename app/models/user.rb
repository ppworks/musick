class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :image, :default_provider_id
  
  has_many :providers_users, :dependent => :destroy
  has_many :providers, :through => :providers_users
  has_and_belongs_to_many :follows, {
    :foreign_key => 'user_id', :association_foreign_key => 'other_user_id', :class_name => 'User',
    :join_table => :follows
  }
  
  has_and_belongs_to_many :followers, {
    :foreign_key => 'other_user_id', :association_foreign_key => 'user_id', :class_name => 'User',
    :join_table => :follows
  }
  has_many :users_artists
  has_many :artists, :through => :users_artists
  
  has_many :users_artist_items
  has_many :artist_items, :through => :users_artist_items
  
  has_many :users_artist_tracks
  has_many :artist_tracks, :through => :users_artist_tracks
  
  def self.find_for_facebook_oauth(auth, current_user = nil)
    providers_user = ProvidersUser.find_by_provider_id_and_user_key Provider.facebook.id, auth['uid']
    begin
      profiles = SocialSync::Facebook.profiles auth['credentials']['token'], {:uid => [auth['uid']]}
      name = profiles[0][:name]
      image = profiles[0][:pic_square]
    rescue => e
      logger.error e
      name = auth['user_info']['name']
      image = auth['user_info']['image'].gsub(/(type=)(.*)/, '\1')
    end
    
    if providers_user.nil?
      if current_user.nil?
        user = User.create!({
          :email => auth['extra']['user_hash']['email'],
          :password => Devise.friendly_token[0,20],
          :name => name,
          :image => image,
          :default_provider_id => Provider.facebook.id
        })
      else
        user = current_user
      end
      providers_user = ProvidersUser.create!({
        :provider_id => Provider.facebook.id,
        :user_id => user.id,
        :user_key => auth['uid'].to_s,
        :access_token => auth['credentials']['token'],
        :name => name,
        :email => auth['extra']['user_hash']['email'],
        :image => image
      })
    else
      user = User.find providers_user[:user_id]
      if user.default_provider_id == Provider.facebook.id
        user.name = name
        user.image = image
        user.save!
      end
      providers_user.name = name
      providers_user.image = image
      providers_user.access_token = auth['credentials']['token']
      providers_user.email = auth['extra']['user_hash']['email']
      providers_user.save!
    end
    user
  end
  
  def self.find_for_mixi_oauth(auth, current_user = nil)
    providers_user = ProvidersUser.find_by_provider_id_and_user_key Provider.mixi.id, auth['uid']
    
    name = auth['user_info']['nickname']
    image = auth['user_info']['image']
    email = "#{auth['uid']}@mixi.example.com" # mixi return no email, so set dummy email address because of email wanne be unique.
    
    if providers_user.nil?
      if current_user.nil?
        user = User.create!({
          :email => email,
          :password => Devise.friendly_token[0,20],
          :name => name,
          :image => image,
          :default_provider_id => Provider.mixi.id
        })
      else
        user = current_user
      end
      providers_user = ProvidersUser.create!({
        :provider_id => Provider.mixi.id,
        :user_id => user.id,
        :user_key => auth['uid'].to_s,
        :access_token => auth['credentials']['token'],
        :refresh_token => auth['credentials']['refresh_token'],
        :name => name,
        :email => email,
        :image => image
      })
    else
      user = User.find providers_user[:user_id]
      if user.default_provider_id == Provider.mixi.id
        user.name = name
        user.image = image
        user.save!
      end
      
      providers_user.name = name
      providers_user.image = image
      providers_user.access_token = auth['credentials']['token']
      providers_user.refresh_token = auth['credentials']['refresh_token']
      providers_user.email = email
      providers_user.save!
    end
    user
  end
  
  def self.find_for_twitter_oauth(auth, current_user = nil)
    providers_user = ProvidersUser.find_by_provider_id_and_user_key Provider.twitter.id, auth['uid']
    
    name = auth['user_info']['nickname']
    image = auth['user_info']['image']
    email = "#{auth['uid']}@twitter.example.com" # twitter return no email, so set dummy email address because of email wanne be unique.
    
    if providers_user.nil?
      if current_user.nil?
        user = User.create!({
          :email => email,
          :password => Devise.friendly_token[0,20],
          :name => name,
          :image => image,
          :default_provider_id => Provider.twitter.id
        })
      else
        user = current_user
      end
      providers_user = ProvidersUser.create!({
        :provider_id => Provider.twitter.id,
        :user_id => user.id,
        :user_key => auth['uid'].to_s,
        :access_token => auth['credentials']['token'],
        :secret => auth['credentials']['secret'],
        :name => name,
        :email => email,
        :image => image
      })
    else
      user = User.find providers_user[:user_id]
      if user.default_provider_id == Provider.twitter.id
        user.name = name
        user.image = image
        user.save!
      end
      
      providers_user.name = name
      providers_user.image = image
      providers_user.access_token = auth['credentials']['token']
      providers_user.secret = auth['credentials']['secret']
      providers_user.email = email
      providers_user.save!
    end
    user
  end
  
  def default_provider
    Provider.select('id, name').find self.default_provider_id
  end
  
  def has_provider? provider_id
    self.providers_users.select(:provider_id).map{|providers_user|providers_user.provider_id}.include? provider_id
  end
  
  def has_all_provider?
    self.providers_users.length === Provider.all.length
  end
  
  def follow user
    self.follows << user unless self.follows.include? user
  end
  
  def make_friend user
    self.follows << user unless self.follows.include? user
    self.followers << user unless self.followers.include? user
  end
  
  def make_fb_friend_auto
    # TODO:cache parameter move to config
    if self.last_sign_in_at.nil? || self.last_sign_in_at < 5.minutes.ago
      friend_user_keys = SocialSync.installed_friends self, {:provider_id => Provider.facebook.id}
      make_friend_auto Provider.facebook.id, friend_user_keys
    end
  end
  
  def make_twitter_friend_auto
    response = SocialSync.friends self, {:provider_id => Provider.twitter.id}
    friend_user_keys = response.map {|f| f[:id]}
    make_friend_auto Provider.twitter.id, friend_user_keys
  end
  
  def make_mixi_friend_auto
    response = SocialSync.friends self, {:provider_id => Provider.mixi.id}
    friend_user_keys = response.map {|f| f[:id]}
    make_friend_auto Provider.mixi.id, friend_user_keys
  end
  
  private
  def make_friend_auto provider_id, friend_user_keys
    user_ids = ProvidersUser
        .where(:provider_id => provider_id)
        .where(:user_key => friend_user_keys)
        .all
        .map!{|user|user.user_id}
      friend_users = User.where(:id => user_ids).all
#      Follow.delete_all(:user_id => self.id)
#      Follow.delete_all(:other_user_id => self.id)
      
      friend_users.each do |user|
        self.make_friend user
      end
  end
end
