class CreatePets < ActiveRecord::Migration[5.2]
  def change
    create_table :pets do |t|
      # user_id: なでているユーザー
      t.integer :user_id
      # cry_id: なでた投稿(鳴き声)
      t.integer :cry_id

      t.timestamps
    end
  end
end
