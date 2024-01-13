# ユーザー
# ユーザーのこと。
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  validates :username, uniqueness: true, length: { in: 4..20 }, format: {
    with: /\A[a-z0-9_]+\z/i,
    message: "は英数字またはアンダーバー(_)のみが使用可能です。"
  }
  validates :display_name, length: { in: 1..50 }
  validates :introduction, length: { maximum: 250 }

  has_many :timelines, dependent: :destroy
  has_many :cries, dependent: :destroy
  has_many :pets, dependent: :destroy
  has_many :user_follows, dependent: :destroy
  has_many :timeline_follows, dependent: :destroy

  has_many :notifications, foreign_key: :receive_user_id, dependent: :destroy
  has_many :sended_notifications, class_name: "Notification", foreign_key: :send_user_id, dependent: :destroy

  def followed_by?(user)
    user.user_follows.where(followed_user_id: id).exists?
  end

  def notifications_any?
    notifications.where(is_checked: false).exists?
  end
end
