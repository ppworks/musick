class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  rescue_from Exception, :with => :catch_exception if Rails.env.production?
  rescue_from Invite::NoInvitationException, :with => :catch_no_invitation_exception
  protected
  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end
  
  def catch_exception e
    logger.info e.to_yaml
  end
  def catch_no_invitation_exception e
    redirect_to sorry_page_path
  end
  
  private
  def extract_locale_from_accept_language_header
    http_accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    if http_accept_language.present?
      http_accept_language.scan(/^[a-z]{2}/).first
    else
      :en
    end
  end
end
