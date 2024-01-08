class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params["username"])
  end

  def edit
    @user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != @user.id
      flash[:danger] = "他のユーザーのプロフィールは編集できません。"
      redirect_to user_path(@user.username)
    end
  end

  def dangeredit
    @user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != @user.id
      flash[:danger] = "他のユーザーのプロフィールは編集できません。"
      redirect_to user_path(@user.username)
    end
  end

  def update
    @user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != @user.id
      flash[:danger] = "他のユーザーのプロフィールは編集できません。"
      redirect_to user_path(@user.username)
      return
    end
    if @user.update(user_params)
      flash[:success] = "プロフィールを更新しました。"
      redirect_to user_path(@user.username)
    else
      # flash.now[:danger] = "プロフィールを更新に失敗しました。"
      render :edit
    end
  end

  def dangerupdate
    @user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != @user.id
      flash[:danger] = "他のユーザーのプロフィールは編集できません。"
      redirect_to user_path(@user.username)
      return
    end
    if @user.update(user_params_danger)
      flash[:success] = "ユーザーネームを変更しました。"
      redirect_to user_path(@user.username)
    else
      # flash.now[:danger] = "プロフィールを更新に失敗しました。"
      render :dangeredit
    end
  end

  private
  def user_params
    params.require(:user).permit(:profile_image, :display_name, :introduction)
  end

  def user_params_danger
    params.require(:user).permit(:username)
  end
end
