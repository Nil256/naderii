class TimelineFollowsController < ApplicationController
  def create
    @timeline = Timeline.find_by(timelinename: params[:timelinename])
    @found_timeline = !(@timeline.nil?)
    if !(user_signed_in?)
      flash.now[:danger] = "タイムラインをフォローするにはログインする必要があります。"
    elsif @found_timeline
      follow = current_user.timeline_follows.new(timeline_id: @timeline.id)
      follow.save
    end
  end

  def destroy
    @timeline = Timeline.find_by(timelinename: params[:timelinename])
    @found_timeline = !(@timeline.nil?)
    if user_signed_in? && @found_timeline
      follow = current_user.timeline_follows.find_by!(timeline_id: @timeline.id)
      follow.destroy
    end
  end
end
