# なで
# 別名: なでる, なでなで
# 他SNSの「いいね」にあたる
# 悲しいこととか、つらいこととか いいねしづらいから、なでにしたのさ
# いいこととかすごいことも 良かったねとなでるのさ
class Pet < ApplicationRecord
  belongs_to :user
  belongs_to :cry
end
