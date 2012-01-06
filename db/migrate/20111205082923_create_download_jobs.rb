class CreateDownloadJobs < ActiveRecord::Migration
  def change
    create_table :download_jobs do |t|
      t.string :title
      t.string :status

      t.timestamps
    end
  end
end
