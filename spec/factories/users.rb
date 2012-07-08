I18n.locale = :en
FactoryGirl.define do
  factory :user, :class => User do
    id 1
    email {Faker::Internet.email}
    password 'password'
    reset_password_token 'token'
    reset_password_sent_at Date.today.to_time
    remember_created_at Date.today.to_time
    sign_in_count 0
    current_sign_in_at Date.today.to_time
    last_sign_in_at Date.yesterday.to_time
    current_sign_in_ip {Faker::Internet.ip_v4_address}
    last_sign_in_ip  {Faker::Internet.ip_v4_address}
    created_at Date.yesterday.to_time
    updated_at Date.today.to_time
    providers_users {
      [Factory.build(:bob_providers_user)]
    }
    name 'bob'
    image 'http://graph.facebook.com/100002694696581/picture?type='
    default_provider_id {Provider.facebook.id}
  end
end
