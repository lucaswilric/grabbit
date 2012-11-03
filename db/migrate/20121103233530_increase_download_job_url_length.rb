class IncreaseDownloadJobUrlLength < ActiveRecord::Migration
  def up
    change_column :download_jobs, :url, :string, :limit => 1023
  end

  def down
    DownloadJob.all.each do |dj|
      dj.url = dj.url[0..254] if dj.url.length > 255
      dj.save!
    end
  
    change_column :download_jobs, :url, :string, :limit => 255
  end
end
