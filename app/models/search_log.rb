class SearchLog < ActiveRecord::Base
  ARTIST = 1
  ARTIST_ITEM = 2
  def self.kinds
    [ARTIST, ARTIST_ITEM]
  end
  
  def self.log opts = {}
    opts.reverse_merge! :user => nil, :keyword => '', :kind => nil, :target_id => nil
    return unless self.kinds.include? opts[:kind]
    user_id = opts[:user].present? ? opts[:user].id : nil
    self.create(:user_id => user_id, :keyword => opts[:keyword], :kind => opts[:kind], :target_id => opts[:target_id])
  end
end
