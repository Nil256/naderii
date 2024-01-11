class CreateUserFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :user_follows do |t|
      # user_id: フォローするユーザー
      t.integer :user_id
      # followed_user_id: フォローされるユーザー
      t.integer :followed_user_id

      t.timestamps
    end
  end
end
