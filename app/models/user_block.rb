# ブロック(ユーザー)
class UserBlock < ApplicationRecord
  validates :user_id, uniqueness: { scope: :blocked_user_id }

  belongs_to :user
end
