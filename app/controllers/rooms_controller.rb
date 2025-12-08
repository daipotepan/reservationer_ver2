class RoomsController < ApplicationController
  def index
    user = User.find_by(id: session[:id])

    if user && Room.column_names.include?("user_id")
      @rooms = user.rooms
    elsif user.nil?
      @rooms = Room.none
    else
      Rails.logger.warn "rooms table missing user_id column — falling back to Room.all"
      @rooms = Room.all
    end
  end

  def show
    @room = Room.find_by(id: params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    user = User.find_by(id: session[:id])
    @room.user = user if user && Room.column_names.include?("user_id")

    if @room.save
      flash[:notice] = "施設の登録に成功しました。"
      redirect_to rooms_path

    else
      flash[:notice] = "施設の登録に失敗しました。"
      render "new", status: :unprocessable_entity
    end
  end

  def room_params
    params.require(:room).permit(:room_img, :name, :introduction, :payment_amount, :address)
  end
end

