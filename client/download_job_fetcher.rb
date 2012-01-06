require 'http_fetcher'
require 'net/http'

require 'rubygems'
require 'json'

class DownloadJobFetcher
  include HttpFetcher
  
  FeedUrl = "#{GrabbitUrl}/download_jobs/tagged/pug/feed"
  SubscriptionUrl = "#{GrabbitUrl}/subscriptions"

  def get_download_jobs
    JSON.parse fetch(FeedUrl).body
  end
  
  def get_subscription(id)  
    JSON.parse fetch("#{SubscriptionUrl}/#{id}.json").body
  end
end

