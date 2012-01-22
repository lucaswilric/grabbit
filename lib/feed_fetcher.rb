require 'http_fetcher'
require 'rss'

class FeedFetcher
  extend HttpFetcher

  @logger = Rails.logger

  def self.fetch_all_feeds(tag = nil)
    @logger.debug "#{ Time.zone.now } [DEBUG] Starting FeedFetcher#fetch_all_feeds, tag = #{ tag }"

    Subscription.all.each do |sub|
      begin
        fetch_feed sub
      rescue RSS::NotWellFormedError
        @logger.error "[ERROR] #{ Time.zone.now } RSS XML at #{ sub.url } was not well formed."
        next
      end
    end

  end

  # Returns the number of new items created, to make testing easier.
  def self.fetch_feed(sub)
  
    @logger.warn "Fetching RSS from " + sub.title + " at " + sub.url
  
    # Get the feed
    xml = fetch(sub.resource.url, false).body
    sub.resource.touch

    new_item_count = 0

    if rss = RSS::Parser.parse(xml, false)
      # reverse the list so that download_jobs are created in chronological order
      rss.items.reverse.each do |item|

        item_url = get_url item, sub.url_element
        
        @logger.warn item_url
        
        next unless item_url and (item.date || Time.at(0)) > sub.created_at

        unless DownloadJob.find_by_url(item_url)
          begin
            dl = DownloadJob.create :subscription => sub, :title => get_name(item,sub), :url => item_url
          rescue => ex
            raise
          end

          new_item_count += 1
        end
      end
    else
      @logger.warn "Could not parse RSS from " + sub.resource.url
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
    item_url.blank? ? nil : item_url
  end

  def self.get_name(item, sub)
    item.title || "#{ sub.name } #{ Time.zone.now.to_s }"
  end
end

