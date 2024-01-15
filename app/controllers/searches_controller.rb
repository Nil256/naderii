class SearchesController < ApplicationController
  def search
    @target = params[:target] || "all"
    @word = params[:word] || ""
    if @word.blank?
      @word = @word.strip
      return
    end
    @timelines = Timeline.none
    @users = User.none
    @cries = Cry.none
    keywords = @word.split(" ")
    if @target == "all" || @target == "timeline"
      keywords.each do |keyword|
        if !(keyword.blank?)
          if @timelines.blank?
            @timelines = Timeline.where("display_name LIKE?","%#{keyword}%")
                     .or(Timeline.where("timelinename LIKE?","%#{keyword}%"))
                     .or(Timeline.where("introduction LIKE?","%#{keyword}%"))
          else
            temp = @timelines
            @timelines = temp.where("display_name LIKE?","%#{keyword}%")
                     .or(temp.where("timelinename LIKE?","%#{keyword}%"))
                     .or(temp.where("introduction LIKE?","%#{keyword}%"))
          end
        end
      end
    end
    if @target == "all" || @target == "user"
      keywords.each do |keyword|
        if !(keyword.blank?)
          if @users.blank?
            @users = User.where("display_name LIKE?","%#{keyword}%")
                 .or(User.where("username LIKE?","%#{keyword}%"))
                 .or(User.where("introduction LIKE?","%#{keyword}%"))
          else
            temp = @users
            @users = temp.where("display_name LIKE?","%#{keyword}%")
                 .or(temp.where("username LIKE?","%#{keyword}%"))
                 .or(temp.where("introduction LIKE?","%#{keyword}%"))
          end
        end
      end
    end
    if @target == "all" || @target == "cry"
      keywords.each do |keyword|
        if !(keyword.blank?)
          if @cries.blank?
            @cries = Cry.where("body LIKE?","%#{keyword}%")
          else
            @cries = @cries.where("body LIKE?","%#{keyword}%")
          end
        end
      end
    end
    @timelines.where(is_dummy: false).order(created_at: :desc).limit(25)
    @users.where(is_administrator: false).order(created_at: :desc).limit(25)
    @cries.order(created_at: :desc).limit(25)
  end
end
