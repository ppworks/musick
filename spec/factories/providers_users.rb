FactoryGirl.define do
  factory :bob_providers_user, :class => ProvidersUser do
    provider_id Provider.facebook.id
    user_key 'user_key_bob'
    access_token 'access_token'
    name 'bob'
    email 'bob@example.com'
  end
end