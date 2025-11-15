class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user
  helper_method :search_address
  helper_method :search_room_info

  def current_user
    @current_user ||= User.find_by(id: session[:id])
  end
end
