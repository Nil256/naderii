# cry
class CreateCries < ActiveRecord::Migration[5.2]
  def change
    create_table :cries do |t|
      # user_id: 鳴いたユーザー
      t.integer :user_id, null: false
      # timeline_id: 鳴いた場所(タイムライン) ※個人タイムラインでは、この値が0になる
      t.integer :timeline_id, null: false
      # body: 鳴き声(本文)
      t.text :body, null: false
      # is_personal: 自分の中で鳴いた(個人タイムラインでの鳴き声)かどうか
      t.boolean :is_personal

      t.timestamps
    end
  end
end
