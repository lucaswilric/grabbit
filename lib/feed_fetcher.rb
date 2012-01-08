require 'http_fetcher'
require 'rss'

class FeedFetcher
  extend HttpFetcher

#  @logger = RAILS_DEFAULT_LOGGER

  def self.fetch_all_feeds(tag = nil)
#    @logger.debug "#{ Time.zone.now } [DEBUG] Starting FeedFetcher#fetch_all_feeds, tags = #{ tag_list }"

    conditions = tag ? [] : ['tags.name = (?)', tag]
  
    Subscription.find(:all, :conditions => conditions).each do |sub|
      begin
        fetch_feed sub
      rescue RSS::NotWellFormedError
#        @logger.error "[ERROR] #{ Time.zone.now } RSS XML at #{ sub.url } was not well formed."
        next
      end
    end

  end

  # Returns the number of new items created, to make testing easier.
  def self.fetch_feed(sub)
  
    return 0 if (sub.resource.updated_at || Time.at(0)) > 1.hour.ago
  
    # Get the feed
    xml = fetch(sub.resource.url, false).body
    sub.resource.touch

    new_item_count = 0

    if rss = RSS::Parser.parse(xml, false)
      # reverse the list so that download_jobs are created in chronological order
      rss.items.reverse.each do |item|
          
        next if item.date < sub.created_at

        item_url = get_url item, sub.url_element
        next unless item_url

        unless DownloadJob.find_by_url(item_url)
          begin
            dl = DownloadJob.create :subscription => sub, :title => get_name(item,sub), :url => item_url
          rescue => ex
            raise
          end

          new_item_count += 1
        end
      end
    end

    new_item_count
  end

  def self.get_url(item, tag)
    item_url = nil

    if tag == 'link'
      item_url = item.link
    elsif tag == 'enclosure' and item.enclosure
      item_url = item.enclosure.url
    end

    # Return nil instead of an empty string
    item_url = nil if item_url == ''
    item_url
  end

  def self.get_name(item, sub)
    item.title || "#{ sub.name } #{ Time.zone.now.to_s }"
  end
end

