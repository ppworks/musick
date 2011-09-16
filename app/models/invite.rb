class Invite < ActiveRecord::Base
  
  after_save :share_to_provider
  
  def self.counter_hash opts = {}
    opts.reverse_merge! :user_id => nil, :provider_id => nil
    
    counter = {}
    self
      .select('`to_user_key`, COUNT(`to_user_key`) AS `cnt`')
      .where(['user_id = ? AND to_provider_id = ?', opts[:user_id], opts[:provider_id]])
      .group('`user_id`, `to_provider_id`, `to_user_key`')
      .all
      .each do |invite|
        counter[invite.to_user_id] = invite.cnt
      end
    counter
  end
  
  protected
  def share_to_provider
    return self.delivered_at.present?
    
    self.update_attribute(:delivered_at, Time.now)
  end
end
