class UserFollowsController < ApplicationController
  def create
    @user = User.find_by(username: params[:username])
    @found_user = !(@user.nil?)
    if !(user_signed_in?)
      flash.now[:danger] = "ユーザーをフォローするにはログインする必要があります。"
    elsif @found_user
      if @user.id == current_user.id
        flash.now[:danger] = "自分自身はフォローできないよ。"
      else
        follow = current_user.user_follows.new(followed_user_id: @user.id)
        follow.save
      end
    end
  end

  def destroy
    @user = User.find_by(username: params[:username])
    @found_user = !(@user.nil?)
    if user_signed_in? && @found_user
      follow = current_user.user_follows.find_by!(followed_user_id: @user.id)
      follow.destroy
    end
  end
end
