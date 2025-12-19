class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update]

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
  end

  def edit
    user = User.find_by(id: session[:id])
    unless user && @room && @room.user_id == user.id
      redirect_to mine_rooms_path, alert: "編集権限がありません。" and return
    end
  end

  def update
    user = User.find_by(id: session[:id])
    unless user && @room && @room.user_id == user.id
      redirect_to mine_rooms_path, alert: "編集権限がありません。" and return
    end

    params_room = room_params.dup
    if params_room[:room_img].respond_to?(:original_filename)
      uploaded = params_room.delete(:room_img)
      filename = "room_#{Time.now.to_i}_#{SecureRandom.hex(6)}_#{uploaded.original_filename}"
      dir = Rails.root.join('public', 'uploads', 'rooms')
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      path = dir.join(filename)
      File.open(path, 'wb') { |f| f.write(uploaded.read) }
      params_room[:room_img] = "/uploads/rooms/#{filename}"
    end

    if @room.update(params_room)
      redirect_to mine_rooms_path, notice: "施設情報を更新しました。"
    else
      flash[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @room = Room.new
  end

  def create
    params_room = room_params.dup
    # Handle uploaded file for room_img
    if params_room[:room_img].respond_to?(:original_filename)
      uploaded = params_room.delete(:room_img)
      filename = "room_#{Time.now.to_i}_#{SecureRandom.hex(6)}_#{uploaded.original_filename}"
      dir = Rails.root.join('public', 'uploads', 'rooms')
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      path = dir.join(filename)
      File.open(path, 'wb') { |f| f.write(uploaded.read) }
      params_room[:room_img] = "/uploads/rooms/#{filename}"
    end

    @room = Room.new(params_room)
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

  def mine
    user = User.find_by(id: session[:id])
    if user
      @rooms = user.rooms
    else
      @rooms = Room.none
    end
  end

  def room_params
    params.require(:room).permit(:room_img, :name, :introduction, :payment_amount, :address)
  end

  def destroy
    user = User.find_by(id: session[:id])
    @room = Room.find_by(id: params[:id])

    if @room && user && @room.user_id == user.id
      @room.destroy
      redirect_to mine_rooms_path, notice: "施設を削除しました。"
    else
      redirect_to mine_rooms_path, alert: "施設の削除に失敗しました。"
    end
  end

  private

  def set_room
    @room = Room.find_by(id: params[:id])
    unless @room
      redirect_to rooms_path, alert: "対象の施設が見つかりませんでした。" and return
    end
  end
end

