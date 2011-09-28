class Post < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :content, :presence => true, :length => {:maximum => 120}

  belongs_to :user
  has_one :posts_user_action
  has_one :user_action, :through => :posts_user_action
  has_many :posts_providers
  has_many :posts_comments, :order => :created_at
  has_many :posts_likes, :include => :user
  
  scope :exists, where('show_flg = TRUE')
  
  before_create :init_synced_at
  def init_synced_at
    self.synced_at = Time.now
  end
  
  # get friend's recently posts
  def self.friend_recently user
    friends = user.follows + [user]
    friend_ids = friends.map {|f|f.id}
    ids = Post.select('MAX(id) AS id').where(:user_id => friend_ids).group(:user_id).map {|p|p.id}
    posts = Post.includes(:user).includes(:face).includes(:posts_likes).where(:id => ids).order('id DESC')
  end
  
  # post to remote 
  def remote! provider_ids = [], params = {}
    if provider_ids.blank?
      provider_ids << self.user.default_provider.id
    end
    return false unless (self.valid?)
    provider_ids.each do |provider_id|
      if provider_id == Provider.facebook.id
        opts = params.merge(:provider_id => provider_id, :message => self.content + "\n\n")
      else
        if params[:link]
          opts = {:provider_id => provider_id, :message => self.content + " #{params[:link]} #{APP_CONFIG[:hash_tag]}"}
        else
          opts = {:provider_id => provider_id, :message => self.content}
        end
      end
      res = SocialSync.post! self.user, opts
      self.posts_providers << PostsProvider.new({:provider_id => provider_id, :post_key => res.identifier})
    end
    self.save!
  end
  
  # sync post's comment via provider
  def sync!
    # TODO:cache parameter move to config

    if 30.seconds.ago < self.synced_at
      return false
    end
    # TODO:cache
    # OPTIMIZE: too long method and too much each loop.
    
    
    self.posts_providers.each do |posts_provider|
      posts_likes_user_keys = []
      self.posts_likes.where(:provider_id => posts_provider.provider_id).each do |posts_like|
        posts_likes_user_keys << posts_like.user_key
      end
      
      posts_comments_keys = []
      self.posts_comments.where(:provider_id => posts_provider.provider_id).each do |posts_comment|
        posts_comments_keys << posts_comment.post_key
      end
      res = SocialSync.stream self.user, {:post_key => posts_provider.post_key, :provider_id => posts_provider.provider_id}

      next if res.blank?
      user_keys = res.to_yaml.scan(/:user_key: "([\S]+)"/).uniq
      user_ids_by_user_keys = {}
      ProvidersUser
        .where(:provider_id => posts_provider.provider_id)
        .where(:user_key => user_keys)
        .all
        .each do |u|
          user_ids_by_user_keys[u.user_key] = u.user_id
      end
      
      # create ProviderProfile for provider which don't support fetch unfriend's profile info.
      if res[:provider_profiles].present?
        res[:provider_profiles].each do |user_key, profile|
          provider_profile = ProviderProfile.find_by_provider_id_and_user_key(
            profile[:provider_id],
            profile[:user_key]
          ) || ProviderProfile.new
          provider_profile.attributes = profile
          provider_profile.save
        end
      end
      # create PostsLikes via provider
      provider_posts_likes_user_keys = []
      res[:streams].each do |stream|
        # create PostsLikes via provider
        stream[:likes].each do |like|
          user_key = like[:user_key].to_s
          provider_posts_likes_user_keys << user_key
          user_id = user_ids_by_user_keys[user_key]
          unless posts_likes_user_keys.include? user_key
            self.posts_likes << PostsLike.new({
              :user_id => user_id,
              :provider_id => posts_provider.provider_id,
              :user_key => user_key
            })
          end
        end
        
        # delete PostsLikes if not exists in provider
        self.posts_likes.where(:provider_id => posts_provider.provider_id).each do |posts_like|
          unless provider_posts_likes_user_keys.include? posts_like.user_key
            posts_like.destroy
          end
        end
        # create PostsComment via provider
        provider_posts_keys = []
        stream[:comments].each do |posts_comment|
          post_key = posts_comment[:post_key].to_s
          user_id = user_ids_by_user_keys[posts_comment[:user_key]]
          provider_posts_keys << post_key
          unless posts_comments_keys.include? post_key
            self.posts_comments << PostsComment.new({
              :provider_id => posts_provider.provider_id,
              :post_key => post_key,
              :user_id => user_id,
              :user_key => posts_comment[:user_key],
              :content => posts_comment[:content],
              :created_at => posts_comment[:created_at]
            })
          end
        end
        
        # delete posts_comments if not exists in provider
        self.posts_comments.where(:provider_id => posts_provider.provider_id).each do |posts_comment|
          unless provider_posts_keys.include? posts_comment.post_key
            posts_comment.destroy
          end
        end
      end # res[:streams].each
      
      # sync posts_comments_likes
      provider_posts_comments_likes_user_keys = []
      # create PostsCommentsLikes via provider
      self.posts_comments.where(:provider_id => posts_provider.provider_id).each do |posts_comment|
        # check like user_key on local db
        posts_comments_likes_user_keys = []
        posts_comment.posts_comments_likes.each do |posts_comments_like|
          posts_comments_likes_user_keys << posts_comments_like.user_key
        end
        
        post_key = posts_comment.post_key
        res[:comment_likes].each do |comment_like|
          unless comment_like[:post_key] == post_key
            next
          end
          user_key = comment_like[:user_key].to_s
          provider_posts_comments_likes_user_keys << user_key
          user_id = user_ids_by_user_keys[user_key]
          unless posts_comments_likes_user_keys.include? user_key
            # exists only on provider
            posts_comment.posts_comments_likes << PostsCommentsLike.new({
              :user_id => user_id,
              :provider_id => posts_provider.provider_id,
              :user_key => user_key
            })
          end
        end # self.posts_comments.each
        # delete PostsCommentsLikes if not exists on provider
        posts_comment.posts_comments_likes.where(:provider_id => posts_provider.provider_id).each do |posts_comments_like|
          unless provider_posts_comments_likes_user_keys.include? posts_comments_like.user_key
            posts_comments_like.destroy
          end
        end
      end
    end #self.posts_providers.each
    self.synced_at = Time.now
    self.save
    self.reload
    return true
  end
  
  concerned_with :artist
  concerned_with :artist_item
  concerned_with :artist_track
end
