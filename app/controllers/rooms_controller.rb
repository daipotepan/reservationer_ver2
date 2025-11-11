class RoomsController < ApplicationController
  def index
    @rooms = Room.find_by(id: session[:id]).all
  end

  def show
    @room = Room.find_by(id: session[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(params.require(:room).permit(:room_img, :name, :introduction, :payment_amount, :address))
    if @room.save
      flash[:notice] = "施設の登録に成功しました。"
      redirect_to rooms_path

    else
      flash[:notice] = "施設の登録に失敗しました。"
      render "new", status: :unprocessable_entity
    end
  end

end

