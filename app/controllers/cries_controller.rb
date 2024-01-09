class CriesController < ApplicationController
  def publiccreate
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    if !(user_signed_in?)
      flash[:danger] = "投稿するにはログインする必要があります"
      redirect_to timeline_path(@timeline.timelinename)
      return
    end
    @cry = current_user.cries.new(cry_params)
    @cry.timeline_id = @timeline.id
    @cry.is_personal = false
    if @cry.save
      flash[:success] = "投稿できたよ！"
      redirect_to timeline_path(@timeline.timelinename)
    else
      render "timelines/show"
    end
  end

  def privatecreate
    if !(user_signed_in?)
      flash[:danger] = "投稿するにはログインする必要があります"
      redirect_to new_user_session_path
      return
    end
    @cry = current_user.cries.new(cry_params)
    @cry.timeline_id = 0
    @cry.is_personal = true
    if @cry.save
      flash[:success] = "投稿できたよ！"
      redirect_to user_path(@user.username)
    else
      @user = current_user
      render "users/show"
    end
  end

  def show
  end

  def destroy
  end

  private
  def cry_params
    params.require(:cry).permit(:body)
  end
end
