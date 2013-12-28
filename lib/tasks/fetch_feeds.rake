require 'feed_fetcher'

desc "Fetch new data from all subscriptions"
task :fetch_feeds => :environment do
  FeedFetcher.fetch_all_feeds
end

desc "Persistent job to keep fetching feeds forever"
task :fetch_feeds_forever => :environment do
  puts "START"
     
  until 2 < 1 do
    puts "Fetching feeds at [#{Time.now}]"
                                    
    FeedFetcher.fetch_all_feeds

    sleep(300)
  end
end
