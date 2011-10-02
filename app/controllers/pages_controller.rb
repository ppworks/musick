class PagesController < ApplicationController
  before_filter :check_locale
  
  protected
  def check_locale
    case I18n.locale
      when :ja
        render "#{params[:action]}.#{I18n.locale}"
      else
        render "#{params[:action]}.ja"
    end
  end
end