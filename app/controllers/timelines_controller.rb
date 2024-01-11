class TimelinesController < ApplicationController
  def index
    #@timelines = Timeline.all
    @timelines = Timeline.where(is_dummy: false)
    # @following_timelines = Timeline.where
  end

  def search
  end

  def new
    @timeline = Timeline.new
    @randomname = SecureRandom.alphanumeric(16)
    if !user_signed_in?
      flash[:danger] = "タイムラインを作成するにはログインする必要があります。"
      redirect_to timelines_path
    end
  end

  def create
    if !user_signed_in?
      flash[:danger] = "タイムラインを作成するにはログインする必要があります。"
      redirect_to timelines_path
      return
    end
    @timeline = current_user.timelines.new(timeline_params_new)
    if @timeline.save
      flash[:success] = "タイムライン作ったよ！"
      redirect_to timeline_path(@timeline.timelinename)
    else
      @randomname = params[:timeline][:timelinename]
      render :new
    end
  end

  def show
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    if @timeline.is_dummy
      raise ActiveRecord::RecordNotFound.new("Couldn't find Timeline")
      return
    end
    @cry = Cry.new
  end

  def edit
    @timeline = Timeline.find_by(timelinename: params[:timelinename])
    if !user_signed_in? || @timeline.user_id != current_user.id
      flash[:danger] = "タイムラインの編集はそのタイムラインの管理者でないとできません。"
      redirect_to timeline_path(@timeline.timelinename)
    end
  end

  def update
    @timeline = Timeline.find_by(timelinename: params[:timelinename])
    if !user_signed_in? || @timeline.user_id != current_user.id
      flash[:danger] = "タイムラインの編集はそのタイムラインの管理者でないとできません。"
      redirect_to timeline_path(@timeline.timelinename)
      return
    end
    if @timeline.update(timeline_params)
      redirect_to timeline_path(@timeline.timelinename)
    else
      render :edit
    end
  end

  def destroy
  end

  private
  def timeline_params_new
    params.require(:timeline).permit(:timelinename, :display_name)
  end

  def timeline_params
    params.require(:timeline).permit(:display_name, :introduction)
  end
end
