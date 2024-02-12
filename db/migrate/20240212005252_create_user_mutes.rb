class CreateUserMutes < ActiveRecord::Migration[5.2]
  def change
    create_table :user_mutes do |t|
      # user_id: ユーザー
      t.integer :user_id
      # muted_user_id: ミュートされるユーザー
      t.integer :muted_user_id

      t.timestamps
    end
  end
end
