class IndexTags < ActiveRecord::Migration
  def change
    add_index :tags, [:name, :id]
  end
end
