class Tag < ActiveRecord::Base
  has_and_belongs_to_many :download_jobs
  has_and_belongs_to_many :subscriptions
  
  def download_jobs_for_feed(count, user = nil)
  	user_id = user ? user.id : nil
  
  	download_jobs.where(:status => [Status[:not_started], Status[:retry]], :user_id => [nil, user_id]).order('download_jobs.id desc').limit(count)
  end
end
