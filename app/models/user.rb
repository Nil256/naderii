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
end
