module ApplicationHelper
  def fb_connect_js opts = {}
    uri = "//connect.facebook.net/{locale}/all.js"
    case I18n.locale
      when :ja
        uri.sub '{locale}', 'ja_JP'
      else
        uri.sub '{locale}', 'en_US'
    end
  end
  
  def css_locale
    case I18n.locale
      when :ja
        :ja
      else
        :en
    end
  end
  
  def current_url
    url = request.url.gsub(/(#|\?).*/, '')
    url = "#{url}/"
    url.gsub(/\/\/$/, '/')
  end
end
