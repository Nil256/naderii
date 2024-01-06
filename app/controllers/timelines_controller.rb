class TimelinesController < ApplicationController
  def index
    @timelines = Timeline.all
    # @following_timelines = Timeline.where
  end

  def search
  end

  def show
  end

  def new
    @timeline = Timeline.new
  end

  def create
    if !user_signed_in?
      flash[:danger] = "タイムラインを作成するにはログインする必要があります。"
      redirect_to timelines_path
    end
    @timeline = current_user.timelines.new(timeline_params)
    if @timeline.save
      flash[:success] = "タイムラインを作成しました。"
      redirect_to timelines_path
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def timeline_params
    params.require(:timeline).permit(:timelinename, :display_name)
  end
end
