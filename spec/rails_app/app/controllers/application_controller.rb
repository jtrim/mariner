class ApplicationController < ActionController::Base
  protect_from_forgery

  def normal; end
  def condensed; end
end
