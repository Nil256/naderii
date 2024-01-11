class AddIsAdministratorToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_administrator, :boolean, default: false, null: false
  end
end
