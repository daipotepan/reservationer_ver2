class UsersController < ApplicationController
  def index
  @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    permitted = params.require(:user).permit(:name, :email, :password, :conf_password, :icon, :introduction)

    # Create user without icon first (so we have an id to name the file)
    @user = User.new(permitted.except(:icon))
    if @user.save
      # Handle uploaded icon (store under public/uploads/icons and save path)
      if permitted[:icon].respond_to?(:original_filename)
        uploaded = permitted[:icon]
        filename = "user_#{@user.id}_#{SecureRandom.hex(8)}_#{uploaded.original_filename}"
        dir = Rails.root.join('public', 'uploads', 'icons')
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
        path = dir.join(filename)
        File.open(path, 'wb') { |f| f.write(uploaded.read) }
        @user.update_column(:icon, "/uploads/icons/#{filename}")
      end

      session[:id] = @user.id
      flash[:notice] = "登録が完了しました。"
      redirect_to reservations_path
    else
      flash[:alert] = "ユーザー登録に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit_account
    @user = User.find_by(id: session[:id])
  end

  def edit_profile
    @user = User.find_by(id: session[:id])
  end

  def update_account
    @user = User.find_by(id: session[:id])
    if @user.update(params.require(:user).permit(:email, :password))
      @user.conf_password = @user.password
      flash[:notice] = "アカウントの編集に成功しました。"
      redirect_to users_path
    else
      flash[:notice] = "編集に失敗しました。"
      render "edit_account", status: :unprocessable_entity
    end
  end

  def update_profile
    @user = User.find_by(id: session[:id])
    user_params = params.require(:user).permit(:icon, :name, :introduction)

    # Handle uploaded file for icon (store under public/uploads/icons and save path)
    if user_params[:icon].respond_to?(:original_filename)
      uploaded = user_params.delete(:icon)
      filename = "user_#{@user.id}_#{SecureRandom.hex(8)}_#{uploaded.original_filename}"
      dir = Rails.root.join('public', 'uploads', 'icons')
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      path = dir.join(filename)
      File.open(path, 'wb') { |f| f.write(uploaded.read) }
      # Save relative URL
      user_params[:icon] = "/uploads/icons/#{filename}"
    end

    if @user.update(user_params)
      flash[:notice] = "プロフィールの編集に成功しました。"
      redirect_to users_path
    else
      flash[:alert] = "編集に失敗しました。"
      render "edit_profile", status: :unprocessable_entity
    end
  end

  def login
    if request.post?
      user_params = params.require(:user).permit(:email, :password)
      @user = User.find_by(email: user_params[:email])
      if @user && @user.password == user_params[:password]
        session[:id] = @user.id
        flash[:notice] = "ログインしました。"
        redirect_to reservations_path
      else
        flash[:alert] = "メールアドレスまたはパスワードが違います。"
        render :login, status: :unprocessable_entity
      end
    else
      @user = User.new
    end
  end

  def logout
    session[:id] = nil
    flash[:notice] = "ログアウトしました。"
    redirect_to login_users_path
  end
end
