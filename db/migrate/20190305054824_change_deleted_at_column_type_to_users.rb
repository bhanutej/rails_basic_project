class ChangeDeletedAtColumnTypeToUsers < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :deleted_at
    add_column :users, :deleted_at, :datetime
  end

  def down
    remove_column :users, :deleted_at
    add_column :users, :deleted_at, :time
  end
end
