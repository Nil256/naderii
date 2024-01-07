class TimelinesController < ApplicationController
  def index
    @timelines = Timeline.all
    # @following_timelines = Timeline.where
  end

  def search
  end

  def show
    @timeline = Timeline.find_by(timelinename: params[:timelinename])
  end

  def new
    @timeline = Timeline.new
  end

  def create
    if !user_signed_in?
      flash[:danger] = "タイムラインを作成するにはログインする必要があります。"
      redirect_to timelines_path
    end
    @timeline = current_user.timelines.new(timeline_params_new)
    if @timeline.save
      flash[:success] = "タイムラインを作成しました。"
      redirect_to timeline_path(@timeline.timelinename)
    else
      render :new
    end
  end

  def edit
    @timeline = Timeline.find_by(timelinename: params[:timelinename])
  end

  def update
    @timeline = Timeline.find_by(timelinename: params[:timelinename])
    if !user_signed_in? || @timeline.user_id != current_user.id
      flash[:danger] = "タイムラインの編集はそのタイムラインの管理者でないとできません"
      redirect_to timeline_path(@timeline.timelinename)
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
