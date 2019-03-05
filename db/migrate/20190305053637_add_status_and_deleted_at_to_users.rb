class AddStatusAndDeletedAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :status, :integer, default: 1
    add_index :users, :status
    add_column :users, :deleted_at, :Time, default: nil
    add_index :users, :deleted_at
  end
end
