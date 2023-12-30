class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params["username"])
  end

  def edit
    @user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != @user.id
      redirect_to user_path(@user.username), danger: "他のユーザーのプロフィールは編集できません。"
    end
  end

  def dangeredit
    @user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != @user.id
      redirect_to user_path(@user.username), danger: "他のユーザーのプロフィールは編集できません。"
    end
  end

  def update
    @user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != @user.id
      redirect_to user_path(@user.username), danger: "他のユーザーのプロフィールは編集できません。"
    end
    if @user.update(user_params)
      redirect_to user_path(@user.username), success: "プロフィールを更新しました。"
    else
      render :edit
    end
  end

  def dangerupdate
    @user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != @user.id
      redirect_to user_path(@user.username), danger: "他のユーザーのプロフィールは編集できません。"
    end
    if @user.update(user_params_danger)
      redirect_to user_path(@user.username), success: "プロフィールを更新しました。"
    else
      render :edit
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
