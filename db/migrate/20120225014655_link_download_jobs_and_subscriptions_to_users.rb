class LinkDownloadJobsAndSubscriptionsToUsers < ActiveRecord::Migration
  def up
    change_table :download_jobs do |t|
      t.references :user
    end
    
    change_table :subscriptions do |t|
      t.references :user
    end
  end

  def down
    remove_column :download_jobs, :user_id
    remove_column :subscriptions, :user_id  
  end
end
