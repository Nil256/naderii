# フォロー(タイムライン)
class TimelineFollow < ApplicationRecord
  validates :user_id, uniqueness: { scope: :timeline_id }

  belongs_to :user
  belongs_to :timeline
end
