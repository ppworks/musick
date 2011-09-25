# -*- coding: utf-8 -*-
class Post
  # share to Facebook
  def remote! provider_ids = []
    return false unless (self.valid?)
    
    group_id = APP_CONFIG[:group_id]
    if group_id.present?
      target = 'group'
      target_id = group_id
    else
      target = 'user'
      target_id = 'me'
    end
    # TODO: share message change to i18n I18n.t()
    params = {
      :message => I18n.t('musick.social.posts.facebook.message', :message => self.content),
      :name => I18n.t('musick.social.posts.facebook.name'),
      :link => I18n.t('musick.social.posts.facebook.link', :domain => APP_CONFIG[:domain]),
      :description => I18n.t('musick.social.posts.facebook.description'),
      :picture => self.face.path,
      :actions => [{
        :name => I18n.t('musick.social.posts.facebook.actions.name'),
        :link => I18n.t('musick.social.posts.facebook.actions.link', :domain => APP_CONFIG[:domain])
      }],
      :properties => {
        I18n.t('musick.social.posts.facebook.properties.name1') => {
          :text => I18n.t('musick.social.posts.facebook.properties.text1', :user_name => self.user.name), 
          :href => I18n.t('musick.social.posts.facebook.properties.href1', :domain => APP_CONFIG[:domain], :user_id => self.user.id)
        }
      },
      :target => target, :target_id => target_id
    }
    res = SocialSync.post! self.user, params
    self.posts_providers << PostsProvider.new({:provider_id => self.user.default_provider.id, :post_key => res.identifier})
    self.save!
  end
end