class User < ActiveRecord::Base
  include OAuth2::Model::ResourceOwner
  include OAuth2::Model::ClientOwner
  
  has_many :download_jobs
  has_many :subscriptions

  validates :name, :open_id, :presence => true
end
