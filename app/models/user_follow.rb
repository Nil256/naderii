# フォロー(ユーザー)
class UserFollow < ApplicationRecord
  validates :user_id, uniqueness: { scope: :followed_user_id }

  belongs_to :user
end
