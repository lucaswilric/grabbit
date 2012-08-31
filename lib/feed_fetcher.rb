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
      rescue
        error $!.to_s
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
        
        published = item.date if item.is_a? RSS::Rss::Channel::Item
        published = item.published.content if item.is_a? RSS::Atom::Feed::Entry
        published ||= Time.now

        debug "#{item_url} | #{sub.created_at} | #{published.to_s}"
        
        next unless item_url and published > sub.created_at and published > 1.week.ago

        begin
          dl = DownloadJob.create(:subscription => sub, :title => get_name(item,sub), :url => item_url)
          if (dl.id?)
            debug dl.id.to_s
            new_item_count += 1
          else
            warn dl.errors.messages.to_s
          end
        rescue
          error "Problem saving '#{item_url}'. Does it already exist for this subscription?"
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
      item_url = item.link.href if item.is_a? RSS::Atom::Feed::Entry
      item_url = item.link if item.is_a? RSS::Rss::Channel::Item
    elsif tag == 'enclosure' and item.enclosure
      item_url = item.enclosure.url
    end

    # Return nil instead of an empty string
    return nil if item_url.blank?
    
    # Compensate for bug in Al Jazeera English RSS feed, where they (seem to) post every time with a double slash in the URL, then correct it later.
    item_url = item_url.gsub(/\/{2,}/, '/').sub(/:\//, '://')

    # Some numpties put links in their feeds without a scheme.
    item_url = "http://#{item_url}" unless item_url.include?('://')
    
    item_url
  end

  def self.get_name(item, sub)
    t = item.title if item.is_a? RSS::Rss::Channel::Item
    t = item.title.content if item.is_a? RSS::Atom::Feed::Entry
    
    t || "#{ sub.name } #{ Time.zone.now.to_s }"
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

