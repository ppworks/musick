class Invite < ActiveRecord::Base
  INVITE_USER_MAX = 10
  INVITE_KINDS = {
    :facebook => {
      :friend_wall => 11,
      :invite_app => 12
    },
    :twitter => {
      :message => 21,
      :reply => 22
    },
    :mixi => {
      :message => 31
    }
  }
  INVITE_KIND_OPTIONS = {
    :facebook => {
      I18n::t('musick.social.friends.invite_kind.label') => '',
      I18n::t('musick.social.friends.invite_kind.facebook.friend_wall') => INVITE_KINDS[:facebook][:friend_wall],
      #I18n::t('musick.social.friends.invite_kind.facebook.invite_app') => INVITE_KINDS[:facebook][:invite_app],
    },
    :twitter => {
      I18n::t('musick.social.friends.invite_kind.label') => '',
      I18n::t('musick.social.friends.invite_kind.twitter.message') => INVITE_KINDS[:twitter][:message],
      I18n::t('musick.social.friends.invite_kind.twitter.reply') => INVITE_KINDS[:twitter][:reply],
    },
    :mixi => {
      I18n::t('musick.social.friends.invite_kind.label') => '',
      I18n::t('musick.social.friends.invite_kind.mixi.message') => INVITE_KINDS[:mixi][:message],
    }
  }
  validates :user_id,
    :presence => true
  validates :message,
    :presence => true,
    :length => {:in => (1..100)}
  validates :to_invite_kind,
    :presence => true
  
  after_save :send_to_provider
  
  def self.counter_hash opts = {}
    opts.reverse_merge! :user_id => nil, :provider_id => nil
    
    counter = {}
    self
      .select('`to_user_key`, COUNT(`to_user_key`) AS `cnt`')
      .where(['user_id = ? AND to_provider_id = ?', opts[:user_id], opts[:provider_id]])
      .group('`user_id`, `to_provider_id`, `to_user_key`')
      .all
      .each do |invite|
        counter[invite.to_user_key] = invite.cnt
      end
    counter
  end
  
  def self.send_to_friends opts = {}
    opts.reverse_merge! :current_user => nil, :params => {}
    current_user = opts[:current_user]
    params = opts[:params]
    
    profiles = Social::Friend.fetch :current_user => current_user, :provider => params[:provider]
    profile_ids = profiles.map{|profile|profile[:id]}
    to_provider_user_keys = params[:to_provider_user_keys].split ','
    to_provider_user_keys.select! do |to_provider_user_key|
      profile_ids.include? to_provider_user_key.to_s
    end
    
    res = {:errors => nil}
    if to_provider_user_keys.blank?
      res[:errors].generate_message(:to_user_key)
      return res
    end
    ActiveRecord::Base.transaction do
      to_provider_user_keys.each do |to_provider_user_key|
        invite = Invite.new(
          :user_id => current_user.id,
          :message => params[:message],
          :to_provider_id => Provider.send(params[:provider]),
          :to_invite_kind => params[:to_invite_kind],
          :to_user_key => to_provider_user_key
        )
        unless invite.valid?
          res[:errors] = invite.errors
          return res
        end
        invite.save!
      end
    end
    res
  end
  
  def send_to_provider_delayed
    begin
      current_user = User.find self.user_id
      case self.to_invite_kind
        when INVITE_KINDS[:facebook][:friend_wall]
          opts = {
            :target_id => self.to_user_key, :message => self.message,
            :picture => 'http://' + APP_CONFIG[:domain] + '/images/musick.png',
            :description => I18n::t('musick.description'),
            :link => 'http://' + APP_CONFIG[:domain],
            :name => 'Musick'
          }
          res = SocialSync.post!(current_user, opts.merge({:provider_id => Provider.facebook}))
        when INVITE_KINDS[:facebook][:invite_app]
        when INVITE_KINDS[:twitter][:message]
          opts = {
            :target_id => self.to_user_key.to_i, :message => self.message + 'http://' + APP_CONFIG[:domain] + ' ' + APP_CONFIG[:hash_tag],
          }
          res = SocialSync.message!(current_user, opts.merge({:provider_id => Provider.twitter}))
        when INVITE_KINDS[:twitter][:reply]
          opts = {
            :uid => self.to_user_key.to_i
          }
          profiles = SocialSync.profiles(current_user, opts.merge({:provider_id => Provider.twitter}))
          screen_name = ''
          if profiles.present?
            screen_name = profiles[0][:screen_name]
          end
          opts = {
            :target_id => self.to_user_key, :message => "@#{screen_name} " + self.message + ' http://' + APP_CONFIG[:domain] + ' ' + APP_CONFIG[:hash_tag],
          }
          res = SocialSync.post!(current_user, opts.merge({:provider_id => Provider.twitter}))
        when INVITE_KINDS[:mixi][:message]
          opts = {
            :target_id => self.to_user_key, 
            :title => I18n::t('musick.social.friends.invite_title'),
            :message => self.message + "\n\n" + 'http://' + APP_CONFIG[:domain],
          }
          res = SocialSync.message!(current_user, opts.merge({:provider_id => Provider.mixi}))
        else
      end
      self.update_attribute(:delivered_at, Time.now)
    rescue => e
      logger.info e.to_yaml
    end
  end
  
  protected
  def send_to_provider
    return if self.delivered_at.present?
    self.delay.send_to_provider_delayed
  end
end
