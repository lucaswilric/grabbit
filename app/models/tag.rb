class Tag < ActiveRecord::Base
  has_and_belongs_to_many :download_jobs
  has_and_belongs_to_many :subscriptions
end
