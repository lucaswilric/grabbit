class AddShowSourceToTags < ActiveRecord::Migration
  def change
    add_column :tags, :show_source, :boolean, :not_null => true, :default => true
  end
end
