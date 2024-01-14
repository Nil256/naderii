class CriesController < ApplicationController
  def publiccreate
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    if @timeline.is_dummy
      raise ActiveRecord::RecordNotFound.new("Couldn't find Timeline")
      return
    end
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
      @cries = @timeline.cries.order(created_at: :desc)
      render "timelines/show"
    end
  end

  def privatecreate
    if !(user_signed_in?)
      flash[:danger] = "投稿するにはログインする必要があります。"
      redirect_to new_user_session_path
      return
    end
    dummy_timeline = Timeline.find_by(is_dummy: true)
    if dummy_timeline.nil?
      redirect_to home_path
      return
    end
    @cry = current_user.cries.new(cry_params)
    logger.debug cry_params
    @cry.timeline_id = dummy_timeline.id
    @cry.is_personal = true
    if @cry.save
      flash[:success] = "投稿できたよ！"
      redirect_to home_path
    else
      @cries = Cry.where(user_id: [current_user.id, *current_user.user_follows.pluck(:followed_user_id)])
           .or(Cry.where(timeline_id: current_user.timeline_follows.pluck(:timeline_id)))
           .order(created_at: :desc)
      @can_post_private_cry = true
      render "homes/main"
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
      flash.now[:danger] = "他の人の投稿を削除することはできません。"
    end
    if prev_page == "tl"
      redirect_to timeline_path(cry.timeline.timelinename)
    elsif prev_page == "home" && user_signed_in?
      redirect_to home_path
    else
      redirect_to user_path(cry.user.username)
    end
  end

  private
  def cry_params
    params.require(:cry).permit(:body)
  end
end
