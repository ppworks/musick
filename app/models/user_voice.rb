class UserVoice < ActiveRecord::Base
  validates :message, :presence => true
end
