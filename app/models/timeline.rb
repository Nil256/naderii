# タイムライン
# なでりーでは、基本的に鳴き声(投稿)は何らかのタイムラインに属する。
# 何かしらの共通の話題でタイムラインを作成し、そこでユーザーたちが鳴き合う。
# 唯一、個人タイムライン(ユーザーのプロフィール欄)で投稿したもののみ、どのタイムラインにも属さない。
# 個人タイムラインは、データベース上にはタイムラインとして存在せず、個人タイムラインでの鳴き声かどうかはCryモデルのis_personalで判定する。
class Timeline < ApplicationRecord
  validates :timelinename, uniqueness: true, length: { in: 4..20 }, format: {
    with: /\A[a-z0-9_]+\z/i,
    message: "は英数字またはアンダーバー(_)のみが使用可能です。"
  }
  validates :display_name, length: { in: 1..50 }
  validates :introduction, length: { maximum: 250 }

  belongs_to :user
  has_many :cries, dependent: :destroy
  has_many :timeline_follows, dependent: :destroy

  has_many :notifications, dependent: :destroy

  def followd_by?(user)
    timeline_follows.where(user_id: user.id).exists?
  end
end
