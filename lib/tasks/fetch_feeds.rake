require 'feed_fetcher'

desc "Fetch new data from all subscriptions"
task :fetch_feeds => :environment do
  FeedFetcher.fetch_all_feeds
end
