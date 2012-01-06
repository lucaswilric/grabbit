class MoveUrlToDownloadJob < ActiveRecord::Migration
  def up
    change_table :download_jobs do |t|
      t.string :url
    end
    
#    execute "update download_jobs set url = url from resources where resources.id = download_jobs.resource_id"
    
    remove_column :download_jobs, :resource_id
  end

  def down
  end
end
