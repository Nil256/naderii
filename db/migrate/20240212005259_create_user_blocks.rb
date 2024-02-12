class CreateUserBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_blocks do |t|
      # user_id: ユーザー
      t.integer :user_id
      # blocked_user_id: ブロックされるユーザー
      t.integer :blocked_user_id

      t.timestamps
    end
  end
end
