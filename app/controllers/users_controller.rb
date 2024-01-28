class UsersController < ApplicationController
  def following
    if !(user_signed_in?)
      redirect_to new_user_session_path
      return
    end
    @users = User.where(id: current_user.user_follows.pluck(:followed_user_id), is_administrator: false)
  end

  def show
    @user = User.find_by!(username: params["username"])
    if @user.is_administrator && @user.id != current_user.id
      raise ActiveRecord::RecordNotFound.new("Couldn't find User")
      return
    end
    @cries = @user.cries.order(created_at: :desc).page(params[:page])
    # @cry = Cry.new
  end

  def edit
    @user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != @user.id
      flash[:danger] = "他のユーザーのプロフィールは編集できません。"
      redirect_to user_path(@user.username)
    end
  end

  def dangeredit
    @user = User.find_by!(username: params["username"])
    @correct_username = @user.username
    @opened_username = "false"
    @can_delete_with_transfer = !(User.find_by(is_administrator: true).nil?)
    if !(user_signed_in?) || current_user.id != @user.id
      flash[:danger] = "他のユーザーのプロフィールは編集できません。"
      redirect_to user_path(@user.username)
    end
  end

  def update
    @user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != @user.id
      flash[:danger] = "他のユーザーのプロフィールは編集できません。"
      redirect_to user_path(@user.username)
      return
    end
    if @user.update(user_params)
      flash[:success] = "プロフィールを更新したよ！"
      redirect_to user_path(@user.username)
    else
      render :edit
    end
  end

  def dangerupdate
    @user = User.find_by!(username: params["username"])
    @correct_username = @user.username
    if !(user_signed_in?) || current_user.id != @user.id
      flash[:danger] = "他のユーザーのプロフィールは編集できません。"
      redirect_to user_path(@user.username)
      return
    end
    if @user.update(user_params_danger)
      flash[:success] = "ユーザーネームを変更しました。"
      redirect_to user_path(@user.username)
    else
      @opened_username = "true"
      @can_delete_with_transfer = !(User.find_by(is_administrator: true).nil?)
      render :dangeredit
    end
  end

  def destroy
    user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != user.id
      flash[:danger] = "他のユーザーを削除しようとしないでください。"
      redirect_to user_path(user.username)
      return
    end
    # 先にタイムラインの譲渡の申請を全て拒否
    transferrequests = Notification.where(receive_user_id: user.id, action: "TimelineTransferRequest")
    _systemuser = User.find_by(is_administrator: true)
    transferrequests.each do |transferrequest|
      timeline = get_transferring_timeline(transferrequest)
      if !(timeline.nil?)
        timeline.update(is_transferring: false)
        if !(_systemuser.nil?)
          Notification.new(send_user_id: _systemuser.id, receive_user_id: transferrequest.send_user_id, action: "TimelineTransferReject", timeline_id: transferrequest.timeline_id, additional_messages: user.username).save
        end
      end
      transferrequest.destroy
    end
    # ユーザーの削除
    user.destroy
    redirect_to root_path
  end

  def destroywithtransfertl
    user = User.find_by!(username: params["username"])
    if !(user_signed_in?) || current_user.id != user.id
      flash[:danger] = "他のユーザーを削除しようとしないでください。"
      redirect_to user_path(user.username)
      return
    end
    # タイムラインの譲渡を全て拒否
    transferrequests = Notification.where(receive_user_id: user.id, action: "TimelineTransferRequest")
    _systemuser = User.find_by(is_administrator: true)
    transferrequests.each do |transferrequest|
      timeline = get_transferring_timeline(transferrequest)
      if !(timeline.nil?)
        timeline.update(is_transferring: false)
        if !(_systemuser.nil?)
          Notification.new(send_user_id: _systemuser.id, receive_user_id: transferrequest.send_user_id, action: "TimelineTransferReject", timeline_id: transferrequest.timeline_id, additional_messages: user.username).save
        end
      end
      transferrequest.destroy
    end
    # タイムラインを管理者へ強制譲渡
    if !(_systemuser.nil?)
      user.timelines.each do |tl|
        tl.update(user_id: _systemuser.id, is_transferring: false)
        Notification.where(action: "TimelineTransferRequest", timeline_id: tl.id).destroy_all
      end
    end
    # ユーザーの削除
    user.destroy
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:profile_image, :display_name, :introduction)
  end

  def user_params_danger
    params.require(:user).permit(:username)
  end

  # from notification_controller
  def get_transferring_timeline(notification)
    if notification.receive_user_id != current_user.id
      return nil
    end
    if notification.action != "TimelineTransferRequest" || notification.timeline_id.nil? || notification.send_user_id.nil?
      logger.warn "不正なタイムライン譲渡申請: 譲渡に必要なデータが存在しません。"
      logger.warn "< 通知 >"
      logger.warn "送信したユーザーのID: #{notification.send_user_id}"
      logger.warn "受信したユーザーのID: #{notification.receive_user_id}"
      logger.warn "通知の種類: #{notification.action}"
      logger.warn "譲渡中のタイムラインのID: #{notification.timeline_id}"
      logger.warn "追記: #{notification.additional_messages}"
      return nil
    end
    timeline = Timeline.find_by(id: notification.timeline_id)
    if timeline.nil? || timeline.user_id != notification.send_user_id || !timeline.is_transferring
      logger.warn "不正なタイムライン譲渡申請: タイムラインのデータと矛盾が生じています。"
      logger.warn "< 通知 >"
      logger.warn "送信したユーザーのID: #{notification.send_user_id}"
      logger.warn "受信したユーザーのID: #{notification.receive_user_id}"
      logger.warn "通知の種類: #{notification.action}"
      logger.warn "譲渡中のタイムラインのID: #{notification.timeline_id}"
      logger.warn "追記: #{notification.additional_messages}"
      logger.warn "< タイムライン >"
      if timeline.nil?
        logger.warn "存在しないタイムライン"
        logger.warn "(id: #{notification.timeline_id})"
      else
        logger.warn "ID: #{timeline.id}"
        logger.warn "管理者: #{timeline.user_id}"
        logger.warn "タイムラインネーム: #{timeline.timelinename}"
        logger.warn "譲渡中かどうか: #{timeline.is_transferring}"
      end
      return nil
    end
    return timeline
  end
end
