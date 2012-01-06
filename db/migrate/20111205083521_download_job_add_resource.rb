class DownloadJobAddResource < ActiveRecord::Migration
  def up
    change_table :download_jobs do |t|
      t.references :resource
    end
  end

  def down
    remove_column :download_jobs, :resource_id
  end
end
