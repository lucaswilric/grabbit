require 'tag_holder'
require 'resource_holder'

class XMLTag  
  def initialize(description, value)
    @description = description
    @value = value
  end
  
  def description
    @description
  end
  
  def value
    @value
  end
  
  All = [
      new("Use the file included in each feed item", "enclosure"),
      new("Use the URL each item points to", "link")
  ]
end

class Subscription < ActiveRecord::Base
  belongs_to :resource
  has_many :download_jobs
  has_and_belongs_to_many :tags
  
  include TagHolder
  include ResourceHolder
  
  def self.find_by_tag(tag_name = nil)
    tag = Tag.find_by_name(tag_name)
    tagged = []
    
    if tag
      Subscription.all.each do |s|
        tagged << s if s.tags.include? tag
      end
    end
    
    tagged
  end
end
