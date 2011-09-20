class ProvidersUser < ActiveRecord::Base
  belongs_to :provider
  belongs_to :user
  after_create :update_invites
  
  protected
  def update_invites
    Invite.update_invited_user self
  end
end
