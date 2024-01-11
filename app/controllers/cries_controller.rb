class CriesController < ApplicationController
  def publiccreate
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    if !(user_signed_in?)
      flash[:danger] = "投稿するにはログインする必要があります。"
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
      flash[:danger] = "投稿するにはログインする必要があります。"
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
    @prev_page = params[:prev]
    @prev_page ||= ""
    @cry = Cry.find(params[:id])
  end

  def destroy
    prev_page = params[:prev]
    cry = Cry.find(params[:id])
    if user_signed_in? && cry.user_id == current_user.id
      cry.destroy
      flash.now[:success] = "投稿を削除しました。"
    else
      flash.now[:danger] = "他の人の投稿を消すことはできません。"
    end
    if prev_page == "tl"
      redirect_to timeline_path(cry.timeline.timelinename)
    else
      redirect_to user_path(cry.user.username)
    end
  end

  private
  def cry_params
    params.require(:cry).permit(:body)
  end
end
