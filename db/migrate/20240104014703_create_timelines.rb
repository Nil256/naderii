class CreateTimelines < ActiveRecord::Migration[5.2]
  def change
    create_table :timelines do |t|
      # user_id: タイムラインを作成したユーザー
      t.integer :user_id, null: false
      # timelinename: ユーザーネームのように、タイムラインを識別するためのID
      t.string :timelinename, null: false
      # display_name: タイムラインの表示名 重複しても問題は無い
      t.string :display_name, null: false
      # introduction: タイムラインの概要
      t.text :introduction

      t.timestamps
    end

    # ユーザーを識別するためのIDなので もちろん一意でなければならない
    add_index :timelines, :timelinename, unique: true
  end
end
