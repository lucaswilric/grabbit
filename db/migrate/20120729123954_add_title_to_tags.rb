class AddTitleToTags < ActiveRecord::Migration
  def change
    add_column :tags, :title, :string
  end
end
