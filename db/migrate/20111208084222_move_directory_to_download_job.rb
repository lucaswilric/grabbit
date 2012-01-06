class MoveDirectoryToDownloadJob < ActiveRecord::Migration
  def up
    change_table :download_jobs do |t|
      t.string :directory
    end
    
    remove_column :resources, :directory
  end

  def down
    change_table :resources do |t|
      t.string :directory
    end
    
    remove_column :download_jobs, :directory  end
end
