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

  def room_params
    params.require(:room).permit(:room_img, :name, :introduction, :payment_amount, :address)
  end
end

