Warden::Manager.after_authentication do |user,auth,opts|
  UserAccessLog.create :user_id => user.id, :kind => UserAccessLog::LOGIN
end
Warden::Manager.before_logout do |user, auth, opts|
  UserAccessLog.create :user_id => user.id, :kind => UserAccessLog::LOGOUT
end