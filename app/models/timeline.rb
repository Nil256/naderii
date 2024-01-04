class Timeline < ApplicationRecord
  validates :timelinename, uniqueness: true, length: { in: 4..20 }, format: {
    with: /\A[a-z0-9_]+\z/i,
    message: "は英数字またはアンダーバー(_)のみが使用可能です。"
  }
  validates :display_name, length: { in: 1..50 }
  validates :introduction, length: { maximum: 250 }

  belongs_to :user
end
