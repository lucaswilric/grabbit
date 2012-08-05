class User < ActiveRecord::Base
  has_many :download_jobs
  has_many :subscriptions

  validates :name, :open_id, :presence => true
end
