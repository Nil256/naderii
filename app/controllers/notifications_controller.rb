class NotificationsController < ApplicationController
  def index
    if !(user_signed_in?)
      redirect_to root_path
      return
    end
    @notifications = Notification.where(receive_user_id: current_user.id)
    _administrator = User.find_by(is_administrator: true)
    if !(_administrator.nil?)
      @notifications = @notifications.or(Notification.where(send_user_id: _administrator.id, receive_user_id: _administrator.id))
    end
    @notifications = @notifications.order(created_at: :desc)
    @notifications.each do |notification|
      if notification.action != "TimelineTransferRequest"
        notification.update(is_checked: true)
      end
    end
  end

  def destroy
    if !(user_signed_in?)
      redirect_to root_path
      return
    end
    @notifications = Notification.where(receive_user_id: current_user.id).order(created_at: :desc)
    @notifications.each do |notification|
      if notification.action == "TimelineTransferRequest"
        timeline = get_transferring_timeline(notification)
        if timeline.nil?
          notification.destroy
          flash[:danger] = "不正な譲渡申請が削除されました。"
        end
      else
        notification.destroy
      end
    end
    redirect_to notifications_path
  end

  def timelinetransferaccept
    if !(user_signed_in?)
      # flash[:danger] = "予期せぬエラーが発生しました。"
      redirect_to root_path
      return
    end
    notification = Notification.find(params[:id])
    timeline = get_transferring_timeline(notification)
    if timeline.nil?
      notification.destroy
      flash[:danger] = "不正な譲渡申請です。"
    else
      timeline.update(user_id: current_user.id, is_transferring: false)
      transfers = Notification.where(action: "TimelineTransferRequest", timeline_id: timeline.id)
      transfers.each do |transfer|
        transfer.destroy
      end
      Notification.new(send_user_id: current_user.id, receive_user_id: notification.send_user_id, action: "TimelineTransferAccept", timeline_id: notification.timeline_id).save
      _send = User.find_by(is_administrator: true)
      if _send.nil?
        _send = current_user
      end
      if current_user.is_administrator
        _send = notification.user
      end
      Notification.new(send_user_id: _send.id, receive_user_id: current_user.id, action: "TimelineTransferred", timeline_id: notification.timeline_id).save
      flash[:success] = "タイムラインの譲渡が完了しました。"
    end
    redirect_to notifications_path
  end

  def timelinetransferreject
    if !(user_signed_in?)
      # flash[:danger] = "予期せぬエラーが発生しました。"
      redirect_to root_path
      return
    end
    notification = Notification.find(params[:id])
    timeline = get_transferring_timeline(notification)
    if timeline.nil?
      notification.destroy
      flash[:danger] = "不正な譲渡申請です。"
    else
      timeline.update(is_transferring: false)
      transfers = Notification.where(action: "TimelineTransferRequest", timeline_id: timeline.id)
      transfers.each do |transfer|
        transfer.destroy
      end
      Notification.new(send_user_id: current_user.id, receive_user_id: notification.send_user_id, action: "TimelineTransferReject", timeline_id: notification.timeline_id).save
      flash[:success] = "タイムラインの譲渡を拒否しました。"
    end
    redirect_to notifications_path
  end

  private
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
