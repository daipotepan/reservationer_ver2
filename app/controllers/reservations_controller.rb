class ReservationsController < ApplicationController
  def index
    if params[:room].blank?
      @rooms = Room.all
      return
    end

    address   = params[:room][:address]
    room_info = params[:room][:room_info]

    if address.present?
      @rooms = search_address(address)
    elsif room_info.present?
      @rooms = search_room_info(room_info)
    else
      @rooms = Room.all
    end
  end


  def show
    @reservation = Reservation.find(params[:id])
    @room = @reservation.room
  end

  def new
    @reservation = Reservation.new

    unless params[:room_id].present?
      redirect_to rooms_path, alert: "予約する施設が選択されていません。" and return
    end

    @room = Room.find_by(id: params[:room_id])

    unless @room
      redirect_to rooms_path, alert: "対象の施設が見つかりませんでした。" and return
    end
  end


  def conf
    @reservation = Reservation.new(reservation_params)

    room_id = params[:room_id]
    @room = Room.find_by(id: room_id)

    unless @room
      redirect_to rooms_path, alert: "施設が見つかりません"
      return
    end

    @reservation.room = @room
    @reservation.user_id = session[:id]

    # 🔴 バリデーション実行
    unless @reservation.valid?
      flash.now[:alert] = "入力内容に誤りがあります"
      render :new, status: :unprocessable_entity
      return
    end

    @stay_days = @reservation.stay_days
    @total_payment_amount = @reservation.total_payment_amount
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

  def mine
    user = User.find_by(id: session[:id])
    if user
      @reservations = user.reservations.includes(:room)
    else
      @reservations = Reservation.none
    end
  end

  def destroy
    @reservation = Reservation.find_by(id: params[:id])
    if @reservation && @reservation.user_id == session[:id]
      @reservation.destroy
      redirect_to mine_reservations_path, notice: "予約をキャンセルしました。"
    else
      redirect_to mine_reservations_path, alert: "予約のキャンセルに失敗しました。"
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
