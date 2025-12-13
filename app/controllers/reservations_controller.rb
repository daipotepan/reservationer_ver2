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

    if params[:room_id].present?
      @room = Room.find(params[:room_id])
    else
      redirect_to rooms_path, alert: "予約する施設が選択されていません。"
    end
  end

  def conf
    @reservation = Reservation.new(reservation_params)

    room_id = params[:room_id].presence || reservation_params[:room_id]
    @room = Room.find_by(id: room_id)

    unless @room
      redirect_to new_reservation_path(room_id: room_id), alert: "対象の施設が見つかりませんでした。" and return
    end

    @room_payment_amount = @room.payment_amount
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = session[:id]
    @reservation.room_id = params[:room_id]

    if @reservation.save
      redirect_to reservations_path, notice: "予約完了しました"
    else
      flash[:notice] = "予約に失敗しました。"
      redirect_to new_reservation_path(room_id: params[:room_id])
    end
  end

  private

  def search_address(input_address)
    areas = ["東京", "大阪", "京都", "札幌"]

    areas.each do |area|
      return Room.where("address LIKE ?", "%#{area}%") if input_address.include?(area)
    end

    Room.where("address LIKE ?", "%#{input_address}%")
  end

  def search_room_info(input_room_info)
    Room.where("name LIKE ? OR introduction LIKE ?",
      "%#{input_room_info}%", "%#{input_room_info}%")
  end

  def reservation_params
    params.require(:reservation).permit(
      :checkin_date,
      :checkout_date,
      :number_of_people,
      :user_id,
      :room_id
    )
  end
end
