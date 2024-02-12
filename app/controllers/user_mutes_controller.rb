class UserMutesController < ApplicationController
  def create
    @user = User.find_by(username: params[:username])
    @found_user = !(@user.nil?)
    if !(user_signed_in?)
      flash.now[:danger] = "ユーザーをミュートするにはログインする必要があります。"
    elsif @found_user
      if @user.id == current_user.id
        flash.now[:danger] = "自分自身はミュートできないよ。"
      else
        current_user.user_mutes.new(muted_user_id: @user.id).save
      end
    end
    redirect_to user_path(@user.username)
  end

  def destroy
    @user = User.find_by(username: params[:username])
    @found_user = !(@user.nil?)
    if user_signed_in? && @found_user
      current_user.user_mutes.find_by!(muted_user_id: @user.id).destroy
    end
    redirect_to user_path(@user.username)
  end
end
