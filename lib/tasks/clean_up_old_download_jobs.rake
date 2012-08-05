task :clean_up_old_download_jobs => :environment do
  t = Tag.find_by_name 'persist'
  
  DownloadJob.all.each do |dj|
    dj.delete unless (dj.created_at > 2.weeks.ago) || dj.tags.include?(t)
  end
end
