class Notification < ApplicationRecord
  belongs_to :user, foreign_key: "send_user_id"
  belongs_to :receive_user, class_name: "User", foreign_key: "receive_user_id"

  belongs_to :timeline, optional: true
end
