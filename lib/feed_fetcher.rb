require 'net/http'

require 'http_fetcher'
require 'rss'

class FeedFetcher
  extend HttpFetcher

  @logger = Rails.logger

  def self.fetch_all_feeds(tag = nil)
    debug "Starting FeedFetcher#fetch_all_feeds, tag = '#{ tag }'"

    subscriptions = tag ? Subscription.find_by_tag(tag) : Subscription.all
    subscriptions.each do |sub|
      begin
        fetch_feed sub if sub.resource.updated_at < 5.minutes.ago
      rescue RSS::NotWellFormedError
        error "RSS XML at #{ sub.url } was not well formed."
        next
      end
    end

    debug "Done."
  end

  # Returns the number of new items created, to make testing easier.
  def self.fetch_feed(sub)
  
    debug "Fetching RSS from " + sub.title + " at " + sub.url
  
    # Get the feed
    begin
      xml = fetch(sub.resource.url, false).body
    rescue NotFoundError
      warn "Did not find '#{sub.resource.url}'. Moving on."
      return
    end
    
    sub.resource.touch

    new_item_count = 0

    if rss = RSS::Parser.parse(xml, false)
      # reverse the list so that download_jobs are created in chronological order
      rss.items.reverse.each do |item|

        item_url = get_url item, sub.url_element
        
#        debug item_url
        
        next unless item_url and (item.date || Time.now) > sub.created_at

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
      warn "Could not parse RSS from " + sub.resource.url
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
  
  def self.debug(message)
    if @logger
      @logger.debug message
    else
      print "[DBG] #{ Time.zone.now }: #{message}\n"
    end
  end

  def self.warn(message)
    if @logger
      @logger.warn message
    else
      print "[WRN] #{ Time.zone.now }: #{message}\n"
    end
  end
  
  def self.error(message)
    if @logger
      @logger.error message
    else
      print "[ERR] #{ Time.zone.now }: #{message}\n"
    end
  end
end

