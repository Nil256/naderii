class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :send_user_id
      t.integer :receive_user_id
      t.string :action, default: "", null: false
      t.integer :actioned_target_id
      t.boolean :is_checked, default: false, null: false
      t.text :additional_messages, default: "", null: false

      t.timestamps
    end
  end
end
