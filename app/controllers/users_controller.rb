class UsersController < ApplicationController
  def index
    @user = User.find_by(id: session[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :email, :password, :conf_password, :icon, :introduction))
    if @user.save
      session[:id] = @user.id
      flash[:notice] = "登録が完了しました。ログインしてください。"
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
      flash[:notice] = "アカウントの編集に成功しました。"
      redirect_to login_users_path
    else
      flash[:notice] = "編集に失敗しました。"
      render "edit_account", status: :unprocessable_entity
    end
  end

  def update_profile
    @user = User.find_by(id: session[:id])
    if @user.update(params.require(:user).permit(:icon, :name, :introduction))
      flash[:notice] = "プロフィールの編集に成功しました。"
      redirect_to login_users_path
    else
      flash[:notice] = "編集に失敗しました。"
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
