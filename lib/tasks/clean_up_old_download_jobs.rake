task :clean_up_old_download_jobs => :environment do
  t = Tag.find_by_name 'overnight'
  
  DownloadJob.all.each do |dj|
    unless (dj.created_at > 1.week.ago) || dj.tags.include?(t)
      dj.tags.delete_all
      dj.delete 
    end
  end
end
