# なで
# 別名: なでる, なでなで
# 他SNSの「いいね」にあたる
# 悲しいこととか、つらいこととか いいねしづらいから、なでにしたのさ
# いいこととかすごいことも 良かったねとなでるのさ
class Pet < ApplicationRecord
  validates :user_id, uniqueness: { scope: :cry_id }

  belongs_to :user
  belongs_to :cry
end
