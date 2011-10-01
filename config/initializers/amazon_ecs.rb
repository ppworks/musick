require 'amazon/ecs'
Amazon::Ecs.debug = true
Amazon::Ecs.options = {
  :associate_tag => APP_CONFIG[:amazon_associate_tag],
  :AWS_access_key_id => ENV['AMAZON_KEY'],
  :AWS_secret_key => ENV['AMAZON_SECRET'],
  :country => :jp
}