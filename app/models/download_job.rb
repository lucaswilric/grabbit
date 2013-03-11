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
  # Maximum length of a URL, as defined in the DB.
  UrlMaxLength = 1023

  def validate(record)
    record.errors[:base] << "This item is a duplicate." if pending_download_exists(record)
  end
  
  def pending_download_exists(record)
    search_url = record.url.length > UrlMaxLength ? record.url[0..UrlMaxLength-1] : record.url
  
    jobs = DownloadJob.where(:url => search_url, :subscription_id => record.subscription.try(:id))
    
    job_count = jobs.where(:status => [Status[:not_started], Status[:in_progress], Status[:retry]]).length
    job_count += jobs.where(["status in (?) and updated_at > ?", [Status[:finished], Status[:failed], Status[:cancelled]], 6.months.ago]).length
    
    job_count > 0
  end
end

class DownloadJob < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :user
  has_and_belongs_to_many :tags

  include TagHolder
  extend TagHolder::ClassMethods
  
  validates_with DownloadJobValidator, :on => :create
  
  before_validation :set_initial_attributes, :on => :create
  after_create :adopt_tags_from_subscription
  
  self.per_page = 30
  
  def set_initial_attributes
    self.status = Status[:not_started]
  end

  def adopt_tags_from_subscription
    if self.subscription
      add_tags self.subscription.tags 
      self.save
    end
  end

  def extension
    self.subscription.extension if self.subscription
  end
  
  def destination
    self.subscription.destination if self.subscription
  end
end
