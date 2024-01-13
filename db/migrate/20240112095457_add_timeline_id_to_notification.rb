class AddTimelineIdToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :timeline_id, :integer
  end
end
