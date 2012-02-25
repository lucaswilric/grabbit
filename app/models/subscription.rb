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
  belongs_to :user
  has_many :download_jobs
  has_and_belongs_to_many :tags
  
  include TagHolder
  extend TagHolder::ClassMethods
  include ResourceHolder
end
