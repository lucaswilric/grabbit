class DownloadJobAddTags < ActiveRecord::Migration
  def up
    create_table :download_jobs_tags, :id => false do |t|
      t.references :download_job, :tag
    end
  end

  def down
    drop_table :download_jobs_tags
  end
end
