class ReservationsController < ApplicationController
  
  def index
    if params[:room].blank?
      @rooms = Room.all
      return
    end

    address = params[:room][:address]
    room_info = params[:room][:room_info]

    if address.present?
      @rooms = search_address(address)
    elsif room_info.present?
      @rooms = search_room_info(room_info)
    else
      @rooms = Room.all
    end
  end

  def new
    @reservation = Reservation.new
  end

  def conf(reservation, room_id = nil)
    @conf_reservation = reservation
    @room_payment_amount = Room.find_by(id: params[:id]).payment_amount
  end

  def create
    permitted = params.require(:reservation).permit(:checkin_date, :checkout_date, :number_of_people, :room_id)
    @reservation = Reservation.new(permitted)
    room_id = permitted[:room_id] || params[:room_id]
    @reservation.room_id = room_id if room_id.present?
    conf(@reservation, room_id)

    if @reservation.save
      flash[:notice] = "予約完了しました"
      redirect_to reservations_path
    else
      flash[:notice] = "予約に失敗しました。"
      render "new", status: :unprocessable_entity
    end
  end
end

def search_address()
    address_params = params.require(:room).permit(:address)
    input_address = address_params[:address]
    areas = ["東京", "大阪", "京都", "札幌"]

    areas.each do |area|
      if input_address.include?(area)
        return @search_results = Room.where("address LIKE ?", "%#{area}%")
      end
    end   
    @search_results = Room.where("address LIKE ?", "%#{input_address}%")
  end

  def search_room_info()
    room_params = params.require(:room).permit(:room_info)
    input_room_info = room_params[:room_info]
    @search_results = Room.where("name LIKE ? OR introduction LIKE ?", "%#{input_room_info}%", "%#{input_room_info}%")
  end
