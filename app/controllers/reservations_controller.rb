class ReservationsController < ApplicationController
  
  def index
    @rooms = Room.all
  end

  def new
    @reservation = Reservation.new
  end

  def conf(conf_reservation)
    @conf_reservation = @reservation
    @room_payment_amount = Room.find_by(id: params[:id]).payment_amount
  end

  def create
    @reservation = Reservation.new(params.require(:reservation).permit(:checkin_date, :checkout_date, :number_of_people))
    conf(@reservation)

    if @reservation.save
      flash[:notice] = "予約完了しました"
      redirect_to reservations_path

    else
      flash[:notice] = "予約に失敗しました。"
      render "new", status: :unprocessable_entity
    end
  end
end
