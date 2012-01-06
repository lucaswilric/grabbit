class ResourceRemoveStatus < ActiveRecord::Migration
  def up
    remove_column :resources, :status
  end

  def down
    add_column :resources, :status, :string
  end
end
