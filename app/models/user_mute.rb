# ミュート(ユーザー)
class UserMute < ApplicationRecord
  validates :user_id, uniqueness: { scope: :muted_user_id }

  belongs_to :user
end
