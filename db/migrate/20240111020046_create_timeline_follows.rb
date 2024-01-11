class CreateTimelineFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :timeline_follows do |t|
      # user_id: フォローするユーザー
      t.integer :user_id
      # timeline_id: フォローされるタイムライン
      t.integer :timeline_id

      t.timestamps
    end
  end
end
