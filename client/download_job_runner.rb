require 'http_fetcher'
require 'net/http'

require 'config'

class DownloadJobRunner
  include HttpFetcher

  def update(job, status)
    uri = URI.parse("#{GrabbitUrl}/download_jobs/#{job['id']}.json")
    
    request = Net::HTTP::Put.new(uri.path)
    request.set_form_data :id => job['id'], "download_job[status]" => Status[status]
    
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end
    
    case response
    when Net::HTTPSuccess
      job['status'] = Status[status]
    
      response
    else
      response.value
    end
  end
  
  def run_jobs(jobs = [], do_update = true)
    jobs.each do |job|
      update job, :in_progress if do_update
      
      subscription = DownloadJobFetcher.new().get_subscription(job['subscription_id']) if job['subscription_id']
      
      begin
        destination = get_destination_for job, subscription
        
        open(destination, "wb") do |file|
          file.write( fetch(job['url']).body )
        end

        yield job, subscription if block_given?

        update job, :finished if do_update
      rescue
        update job, :failed if do_update
        raise
      end
    end
  end
  
  def get_destination_for(job, subscription)
    dir_path = get_path_for job, subscription

    file_name = DownloadJobHelper.file_name(job, subscription)
    
    destination = "#{ dir_path }/#{ file_name }"
  end

  def get_path_for(job, subscription)
    # Copy the contents of DestinationRoot to a new instance, so we don't mutate the original.
    dir_path = String.new(DestinationRoot)
     
    dir_path << "/" + DownloadJobHelper.directory(job, subscription)
            
    dir_path = File.expand_path(dir_path.chomp('/'))

    unless dir_path.match /\A#{ DestinationRoot.chomp('/') }/
      raise "Download #{ job.id } tried to save outside '#{ DestinationRoot }', in #{ dir_path }"
    end
    
    Dir.mkdir(dir_path, 0777) unless File.directory?(dir_path)

    dir_path
  end
end
