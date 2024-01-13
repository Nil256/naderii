class RemoveActionedTargetIdIdFromNotification < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :actioned_target_id, :integer
  end
end
