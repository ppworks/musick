class PostsUserAction < ActiveRecord::Base
  belongs_to :user_action
  belongs_to :post
end
