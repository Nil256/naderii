class AddIsTransferringToTimeline < ActiveRecord::Migration[5.2]
  def change
    add_column :timelines, :is_transferring, :boolean, default: false, null: false
  end
end
