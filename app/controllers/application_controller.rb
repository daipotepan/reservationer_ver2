class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:id])
  end
  
  def search_address
    input_address = params.dig(:room, :address)

    if input_address.blank?
      @rooms = Room.all
    else
      areas = ["東京", "大阪", "京都", "札幌"]

      matched_area = areas.find { |area| input_address.include?(area) }

      if matched_area
        @rooms = Room.where("address LIKE ?", "%#{matched_area}%")
      else
        @rooms = Room.where("address LIKE ?", "%#{input_address}%")
      end
    end

    render "reservations/index"
  end
end
