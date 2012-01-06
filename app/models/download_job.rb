require 'tag_holder'

Status = {
    :not_started => "Not Started",
    :in_progress => "In Progress",
    :finished => "Finished",
    :failed => "Failed",
    :retry => "Retry",
    :cancelled => "Cancelled"
}

class DownloadJobValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << "This URL is already waiting to be downloaded" if pending_download_exists(record)
  end
  
  def pending_download_exists(record)
    DownloadJob.where(:url => record.url, :status => [Status[:not_started], Status[:in_progress], Status[:retry]]).length > 0
  end
end

class DownloadJob < ActiveRecord::Base
  belongs_to :subscription
  has_and_belongs_to_many :tags

  include TagHolder
  
  validates_with DownloadJobValidator, :on => :create
  
  before_validation :set_initial_attributes, :on => :create
  after_create :adopt_tags_from_subscription
  
  def set_initial_attributes
    self.status = Status[:not_started]
  end

  def adopt_tags_from_subscription
    if self.subscription
      add_tags self.subscription.tags 
      self.save
    end
  end

  def self.find_by_tag(tag_name = nil)
    tag = Tag.find_by_name(tag_name)
    tagged = []
    
    if tag
      DownloadJob.all.each do |d|
        tagged << d if d.tags.include? tag
      end
    end
    
    tagged
  end
  
  def extension
    self.subscription.extension if self.subscription
  end
  
  def destination
    self.subscription.destination if self.subscription
  end
end
