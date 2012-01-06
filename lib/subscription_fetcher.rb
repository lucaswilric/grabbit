require 'http_fetcher'
require 'rss'

class SubscriptionFetcher
  extend HttpFetcher
  
  def self.get_subscription_from_url(url)
    xml = fetch(url).body
    rss = RSS::Parser.parse(xml, false)
    
    tag = "link"
    rss.items.each do |item|
      tag = "enclosure" if item.enclosure
    end
    
    sub = Subscription.new "url" => url, "tag" => tag, "name" => rss.channel.title.to_s
  end
end
