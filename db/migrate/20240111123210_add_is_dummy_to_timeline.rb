class AddIsDummyToTimeline < ActiveRecord::Migration[5.2]
  def change
    add_column :timelines, :is_dummy, :boolean, default: false, null: false
  end
end
