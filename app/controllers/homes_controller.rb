class HomesController < ApplicationController
  def top
  end

  def main
    if !(user_signed_in?)
      redirect_to root_path
      return
    end
    @cries = Cry.where(user_id: [current_user.id, *current_user.user_follows.pluck(:followed_user_id)])
         .or(Cry.where(timeline_id: current_user.timeline_follows.pluck(:timeline_id)))
         .order(created_at: :desc)
         .page(params[:page])
    @cry = Cry.new
    dummy_timeline = Timeline.find_by(is_dummy: true)
    @can_post_private_cry = !(dummy_timeline.nil?)
  end
end
