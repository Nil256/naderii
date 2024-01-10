# 鳴き声
# 投稿のこと。
# 「なでる」に合わせて「鳴き声」と命名した。
# 言いづらいし分かりづらいので、投稿って言って問題ないです。
class Cry < ApplicationRecord
  validates :body, length: { in: 1..160 }

  belongs_to :user
  belongs_to :timeline
  has_many :pets, dependent: :destroy

  def petted_by?(user)
    pets.where(user_id: user.id).exists?
  end
end
