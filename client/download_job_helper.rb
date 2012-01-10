class DownloadJobHelper
  def self.file_name(job, subscription = nil)
    file = job['url'].sub(/.*\/([^\/]+)\/?\Z/, '\1')
    
    if subscription and subscription['extension']
      unless file.downcase.match /\.#{ subscription['extension'].downcase }\Z/
          file << ".#{ subscription['extension'] }"
      end
    end
    
    file
  end
  
  def self.directory(job, subscription = nil)
    if job['directory'] and job['directory'] != ""
      job['directory']
    elsif subscription and subscription['destination'] and subscription['destination'] != ""
      subscription['destination']
    else
      ""
    end
  end
end
