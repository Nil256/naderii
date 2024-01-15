class TimelinesController < ApplicationController
  def index
    @header = "ランダムなタイムライン"
    @timelines = Timeline.where(is_dummy: false).sample(10)
  end

  def followed
    if user_signed_in?
      @header = "フォロー中のタイムライン"
      @timelines = Timeline.where(id: current_user.timeline_follows.pluck(:timeline_id), is_dummy: false)
      render :index
    end
  end

  def managed
    if user_signed_in?
      @header = "管理中のタイムライン"
      @timelines = Timeline.where(user_id: current_user.id, is_dummy: false)
      render :index
    end
  end

  def new
    @timeline = Timeline.new
    @randomname = SecureRandom.alphanumeric(16)
    if !(user_signed_in?)
      flash[:danger] = "タイムラインを作成するにはログインする必要があります。"
      redirect_to timelines_path
    end
  end

  def create
    if !(user_signed_in?)
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
    @cries = @timeline.cries.order(created_at: :desc).page(params[:page])
    @cry = Cry.new
  end

  def edit
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    if !(user_signed_in?) || @timeline.user_id != current_user.id
      flash[:danger] = "タイムラインの編集はそのタイムラインの管理者でないとできません。"
      redirect_to timeline_path(@timeline.timelinename)
    end
  end

  def dangeredit
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    @correct_timelinename = @timeline.timelinename
    @opened_timelinename = "false"
    @transfer_username = ""
    if @timeline.is_transferring
      transfer = Notification.find_by(action: "TimelineTransferRequest", timeline_id: @timeline.id)
      if !(transfer.nil?)
        user = User.find_by(id: transfer.receive_user_id)
        @transfer_username = user.username if !(user.nil?)
      end
    end
    @transfer_username_error = ""
    @opened_transfer = "false"
    if !(user_signed_in?) || @timeline.user_id != current_user.id
      flash[:danger] = "タイムラインの編集はそのタイムラインの管理者でないとできません。"
      redirect_to timeline_path(@timeline.timelinename)
    end
  end

  def update
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    if !(user_signed_in?) || @timeline.user_id != current_user.id
      flash[:danger] = "タイムラインの編集はそのタイムラインの管理者でないとできません。"
      redirect_to timeline_path(@timeline.timelinename)
      return
    end
    if @timeline.update(timeline_params)
      flash[:success] = "タイムラインを更新したよ！"
      redirect_to timeline_path(@timeline.timelinename)
    else
      render :edit
    end
  end

  def dangerupdate
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    @correct_timelinename = @timeline.timelinename
    if !(user_signed_in?) || @timeline.user_id != current_user.id
      flash[:danger] = "タイムラインの編集はそのタイムラインの管理者でないとできません。"
      redirect_to timeline_path(@timeline.timelinename)
      return
    end
    if @timeline.update(timeline_params_danger)
      flash[:success] = "タイムラインネームを変更しました。"
      redirect_to timeline_path(@timeline.timelinename)
    else
      @opened_timelinename = "true"
      @transfer_username = ""
      @transfer_username_error = ""
      @opened_transfer = "false"
      render :dangeredit
    end
  end

  def transferrequest
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    if !(user_signed_in?) || @timeline.user_id != current_user.id
      flash[:danger] = "タイムラインの編集はそのタイムラインの管理者でないとできません。"
      redirect_to timeline_path(@timeline.timelinename)
      return
    end
    if @timeline.is_transferring
      flash[:danger] = "既にタイムラインの譲渡を行っています。"
      redirect_to timeline_path(@timeline.timelinename)
      return
    end
    @transfer_username = params[:username]
    user = User.find_by(username: @transfer_username)
    if user.nil?
      @correct_timelinename = @timeline.timelinename
      @opened_timelinename = "false"
      @transfer_username_error = "ユーザー\"@#{@transfer_username}\"が見つかりませんでした。"
      @opened_transfer = "true"
      render :dangeredit
    elsif user.id == current_user.id
      @correct_timelinename = @timeline.timelinename
      @opened_timelinename = "false"
      @transfer_username_error = "指定したユーザーは自分自身です。"
      @opened_transfer = "true"
      render :dangeredit
    else
      Notification.new(send_user_id: current_user.id, receive_user_id: user.id, action: "TimelineTransferRequest", timeline_id: @timeline.id).save
      @timeline.update(is_transferring: true)
      flash[:success] = "ユーザー\"@#{@transfer_username}\"にタイムラインの譲渡を申請しました。承諾するまで譲渡は完了しません。"
      redirect_to timeline_path(@timeline.timelinename)
    end
  end

  def transfercancel
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    if !(user_signed_in?) || @timeline.user_id != current_user.id
      flash[:danger] = "タイムラインの編集はそのタイムラインの管理者でないとできません。"
      redirect_to timeline_path(@timeline.timelinename)
      return
    end
    transfers = Notification.where(action: "TimelineTransferRequest", timeline_id: @timeline.id)
    transfers.each do |transfer|
      transfer.destroy
    end
    @timeline.update(is_transferring: false)
    flash[:success] = "タイムラインの譲渡を取り消しました。"
    redirect_to timeline_path(@timeline.timelinename)
  end

  def destroy
    @timeline = Timeline.find_by!(timelinename: params[:timelinename])
    if !(user_signed_in?) || @timeline.user_id != current_user.id
      flash[:danger] = "タイムラインの削除はそのタイムラインの管理者でないとできません。"
      redirect_to timeline_path(@timeline.timelinename)
      return
    end
    transfers = Notification.where(action: "TimelineTransferRequest", timeline_id: @timeline.id)
    transfers.each do |transfer|
      transfer.destroy
    end
    @timeline.destroy
    flash[:success] = "タイムラインを削除しました。"
    redirect_to timelines_path
  end

  private
  def timeline_params_new
    params.require(:timeline).permit(:timelinename, :display_name)
  end

  def timeline_params
    params.require(:timeline).permit(:display_name, :introduction)
  end

  def timeline_params_danger
    params.require(:timeline).permit(:timelinename)
  end
end
