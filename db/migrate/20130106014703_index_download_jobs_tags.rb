class IndexDownloadJobsTags < ActiveRecord::Migration
  def change
    add_index :download_jobs_tags, [:tag_id, :download_job_id]
  end
end
